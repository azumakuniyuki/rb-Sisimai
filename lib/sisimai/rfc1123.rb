module Sisimai
  # Sisimai::RFC1123 is a class related to the Internet host
  module RFC1123
    class << self
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

      # Returns "true" when the given string is a valid hostname
      # @param    [String] argv0 Hostname
      # @return   [Boolean]      false: is not a valid hostname, true: is a valid hostname
      # @since v5.2.0
      def is_validhostname(argv0 = '')
        return false unless argv0
        return false if argv0.size <   4
        return false if argv0.size > 255
        
        return false if argv0.include?(".") == false
        return false if argv0.include?("..")
        return false if argv0.include?("--")
        return false if argv0.start_with?(".")
        return false if argv0.start_with?("-")
        return false if argv0.end_with?("-")

        valid = true
        token = argv0.split('.')
        argv0.upcase.split('').each do |e|
          # Check each characater is a number or an alphabet
          f = e.ord
          valid = false if f <  45;           # 45 = '-'
          valid = false if f == 47;           # 47 = '/'
          valid = false if f >  57 && f < 65; # 57 = '9', 65 = 'A'
          valid = false if f >  90            # 90 = 'Z'
        end
        return false if valid == false
        return false if token[-1] =~ /\d/
        return valid
      end

    end
  end
end

