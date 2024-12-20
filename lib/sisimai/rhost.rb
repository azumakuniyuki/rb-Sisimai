module Sisimai
  # Sisimai::Rhost detects the bounce reason from the content of Sisimai::Fact object as an argument
  # of find() method when the value of rhost of the object is listed in the results of Sisimai::Rhost
  # ->list method. This class is called only Sisimai::Fact class.
  module Rhost
    class << self
      RhostClass = {
        "Aol"         => [".mail.aol.com", ".mx.aol.com"],
        "Apple"       => [".mail.icloud.com", ".apple.com", ".me.com"],
        "Cox"         => ["cox.net"],
        "Facebook"    => [".facebook.com"],
        "FrancePTT"   => [".laposte.net", ".orange.fr", ".wanadoo.fr"],
        "GoDaddy"     => ["smtp.secureserver.net", "mailstore1.secureserver.net"],
        "Google"      => ["aspmx.l.google.com", "gmail-smtp-in.l.google.com"],
        "GSuite"      => ["googlemail.com"],
        "IUA"         => [".email.ua"],
        "KDDI"        => [".ezweb.ne.jp", "msmx.au.com"],
        "MessageLabs" => [".messagelabs.com"],
        "Microsoft"   => [".prod.outlook.com", ".protection.outlook.com", ".onmicrosoft.com", ".exchangelabs.com"],
        "Mimecast"    => [".mimecast.com"],
        "NTTDOCOMO"   => ["mfsmax.docomo.ne.jp"],
        "Outlook"     => [".hotmail.com"],
        "Spectrum"    => ["charter.net"],
        "Tencent"     => [".qq.com"],
        "YahooInc"    => [".yahoodns.net"],
      }.freeze

      # Detect the bounce reason from certain remote hosts
      # @param    [Hash]   argvs  Decoded email data
      # @return   [String]        The value of bounce reason
      def find(argvs)
        return "" if argvs["diagnosticcode"].empty?

        clienthost = argvs["lhost"].downcase
        remotehost = argvs["rhost"].downcase
        domainpart = argvs["destination"].downcase
        rhostclass = ""
        modulename = ""
        return "" if (remotehost + domainpart).empty?

        catch :FINDRHOST do
          # Try to match the hostname patterns with the following order:
          # 1. destination: The domain part of the recipient address
          # 2. rhost: remote hostname
          # 3. lhost: local MTA hostname
          RhostClass.each_key do |e|
            # Try to match the domain part of the recipient address with each value of RhostClass
            next unless RhostClass[e].any? { |a| a.end_with?(domainpart) }
            modulename = 'Sisimai::Rhost::' << e
            throw :FINDRHOST
          end

          RhostClass.each_key do |e|
            # Try to match the remote host with each value of RhostClass
            next unless RhostClass[e].any? { |a| remotehost.end_with?(a) }
            modulename = 'Sisimai::Rhost::' << e
            throw :FINDRHOST
          end

          # Neither the remote host nor the destination did not matched with any value of RhostClass
          RhostClass.each_key do |e|
            # Try to match the client host with each value of RhostClass
            next unless RhostClass[e].any? { |a| clienthost.end_with?(a) }
            modulename = 'Sisimai::Rhost::' << e
            throw :FINDRHOST
          end
        end
        return "" if modulename.empty?

        rhostclass = "sisimai/rhost/" << modulename.downcase.split("::")[2]; require rhostclass
        reasontext = Module.const_get(modulename).find(argvs)
        return "" if reasontext.empty?
        return reasontext
      end
    end
  end
end

