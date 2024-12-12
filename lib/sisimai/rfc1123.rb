module Sisimai
  # Sisimai::RFC1123 is a class related to the Internet host
  module RFC1123
    class << self
      require 'sisimai/string'
      Sandwiched = [
          # (Postfix) postfix/src/smtp/smtp_proto.c: "host %s said: %s (in reply to %s)",
          # - <kijitora@example.com>: host re2.example.com[198.51.100.2] said: 550 ...
          # - <kijitora@example.org>: host r2.example.org[198.51.100.18] refused to talk to me:
          ["host ", " said: "],
          ["host ", " talk to me: "],
          ["while talking to ", ":"], # (Sendmail) ... while talking to mx.bouncehammer.jp.:
          ["host ", " ["],            # (Exim) host mx.example.jp [192.0.2.20]: 550 5.7.0 
          [" by ", ". ["],            # (Gmail) ...for the recipient domain example.jp by mx.example.jp. [192.0.2.1].

          # (MailFoundry)
          # - Delivery failed for the following reason: Server mx22.example.org[192.0.2.222] failed with: 550...
          # - Delivery failed for the following reason: mail.example.org[192.0.2.222] responded with failure: 552..
          ["delivery failed for the following reason: ", " with"],
          ["remote system: ", "("],   # (MessagingServer) Remote system: dns;mx.example.net (mx. -- 
          ["smtp server <", ">"],     # (X6) SMTP Server <smtpd.libsisimai.org> rejected recipient ...
          ["-mta: ", ">"],            # (MailMarshal) Reporting-MTA:      <rr1.example.com>
          [" : ", "["],               # (SendGrid) cat:000000:<cat@example.jp> : 192.0.2.1 : mx.example.jp:[192.0.2.2]...
      ].freeze
      StartAfter = [
          "generating server: ",      # (Exchange2007) en-US/Generating server: mta4.example.org
          "serveur de g",             # (Exchange2007) fr-FR/Serveur de g辿n辿ration
          "server di generazione",    # (Exchange2007) it-CH
          "genererande server",       # (Exchange2007) sv-SE
      ].freeze
      ExistUntil = [
          " did not like our ",       # (Dragonfly) mail-inbound.libsisimai.net [192.0.2.25] did not like our DATA: ...
      ].freeze

      # Returns "true" when the given string is a valid internet host
      # @param    [String] argv0 Hostname
      # @return   [Boolean]      false: is not a valid internet host, true: is a valid interneet host
      # @since v5.2.0
      def is_internethost(argv0 = '')
        return false unless argv0
        return false if argv0.size <   4
        return false if argv0.size > 255
        return false if argv0.include?(".") == false
        return false if argv0.include?("..")
        return false if argv0.include?("--")
        return false if argv0.start_with?(".")
        return false if argv0.start_with?("-")
        return false if argv0.end_with?("-")

        hostnameok = true
        characters = argv0.upcase.split("")
        characters.each do |e|
          # Check each characater is a number or an alphabet
          f = e.ord
          if f <  45            then hostnameok = false; break; end  # 45 = '-'
          if f == 47            then hostnameok = false; break; end  # 47 = '/'
          if f >  57 && f <  65 then hostnameok = false; break; end  # 57 = '9', 65 = 'A'
          if f >  90            then hostnameok = false; break; end  # 90 = 'Z'
        end
        return false if hostnameok == false

        p1 = argv0.rindex(".")
        cv = argv0[p1 + 1, argv0.size - p1]; return false if cv.size > 63
        cv.split("").each do |e|
          # The top level domain should not include a number
          f = e.ord
          if f > 47 && f < 58 then hostnameok = false; break; end
        end
        return hostnameok
      end

      # find() returns a valid internet hostname found from the argument
      # @param    string argv1  String including hostnames
      # @return   string        A valid internet hostname found in the argument
      # @since v5.2.0
      def find(argv1 = "")
        return "" unless argv1
        return "" unless argv1.size > 4

        sourcetext = argv1.downcase
        sourcelist = []
        foundtoken = []
        thelongest = 0
        hostnameis = ""

        # Replace some string for splitting by " "
        # - mx.example.net[192.0.2.1] => mx.example.net [192.0.2.1]
        # - mx.example.jp:[192.0.2.1] => mx.example.jp :[192.0.2.1]
        sourcetext = sourcetext.gsub("[", " [").gsub("(", " (").gsub("<", " <") # Prefix a space character before each bracket
        sourcetext = sourcetext.gsub("]", "] ").gsub(")", ") ").gsub(">", "> ") # Suffix a space character behind each bracket
        sourcetext = sourcetext.gsub(":", ": ").gsub(";", "; ")                 # Suffix a space character behind : and ;
        sourcetext = Sisimai::String.sweep(sourcetext)

        catch :MAKELIST do
          Sandwiched.each do |e|
            # Check a hostname exists between the $e->[0] and $e->[1] at array "Sandwiched"
            # Each array in Sandwiched have 2 elements
            next unless Sisimai::String.aligned(sourcetext, e)

            p1 = sourcetext.index(e[0])
            p2 = sourcetext.index(e[1])
            cw = e[0].size
            next if p1 + cw >= p2

            sourcelist = sourcetext[p1 + cw, p2 - cw - p1].split(" ")
            throw :MAKELIST
          end

          # Check other patterns which are not sandwiched
          StartAfter.each do |e|
            # StartAfter have some strings, not an array
            p1 = sourcetext.index(e); next unless p1
            cw = e.size
            sourcelist = sourcetext[p1 + cw..].split(" ")
            throw :MAKELIST
          end
          ExistUntil.each do |e|
            # ExistUntil have some strings, not an array
            p1 = sourcetext.index(e); next unless p1
            sourcelist = sourcetext[0, p1].split(" ")
            throw :MAKELIST
          end

          sourcelist = sourcetext.split(" ") if sourcelist.size == 0
          throw :MAKELIST
        end

        sourcelist.each do |e|
          # Pick some strings which is 4 or more length, is including "." character
          e.chop! if e[-1, 1] == "." # Remove "." at the end of the string
          e.delete!('[]()<>:;')

          next unless e.size > 3
          next unless e.include?(".")
          next unless Sisimai::RFC1123.is_internethost(e)
          foundtoken << e
        end
        return ""            if foundtoken.size == 0
        return foundtoken[0] if foundtoken.size == 1

        foundtoken.each do |e|
          # Returns the longest hostname
          cw = e.size; next if thelongest >= cw
          hostnameis = e
          thelongest = cw
        end
        return hostnameis
      end
    end
  end
end

