module Sisimai
  # Sisimai::ARF is a decoder for the email returned as a FeedBack Loop report message.
  module ARF
    class << self
      require 'sisimai/lhost'
      require 'sisimai/rfc5322'

      # http://tools.ietf.org/html/rfc5965
      # http://en.wikipedia.org/wiki/Feedback_loop_(email)
      # http://en.wikipedia.org/wiki/Abuse_Reporting_Format
      #
      # Netease DMARC uses:    This is a spf/dkim authentication-failure report for an email message received from IP
      # OpenDMARC 1.3.0 uses:  This is an authentication failure report for an email message received from IP
      # Abusix ARF uses        this is an autogenerated email abuse complaint regarding your network.
      Indicators = Sisimai::Lhost.INDICATORS
      AbuseAddrs = ['staff@hotmail.com', 'complaints@email-abuse.amazonses.com'].freeze
      ReportFrom = "Content-Type: message/feedback-report".freeze
      Boundaries = [
        "Content-Type: message/rfc822",
        "Content-Type: text/rfc822-headers",
        "Content-Type: text/rfc822-header",  # ??
      ].freeze
      ARFPreface = [
        ["this is a", "abuse report"],
        ["this is a", "authentication", "failure report"],
        ["this is a", " report for"],
        ["this is an authentication", "failure report"],
        ["this is an autogenerated email abuse complaint"],
        ["this is an email abuse report"],
      ].freeze

      def description; return 'Abuse Feedback Reporting Format'; end

      # Email is a Feedback-Loop message or not
      # @param    [Hash] heads    Email header including "Content-Type", "From", and "Subject" field
      # @return   [True,False]    true: Feedback Loop
      #                           false: is not Feedback loop
      def is_arf(heads)
        return false unless heads

        # Content-Type: multipart/report; report-type=feedback-report; ...
        return true if Sisimai::String.aligned(heads["content-type"], ["report-type=", "feedback-report"])

        if heads["content-type"].include?("multipart/mixed")
          # Microsoft (Hotmail, MSN, Live, Outlook) uses its own report format.
          # Amazon SES Complaints bounces
          cv = Sisimai::Address.s3s4(heads['from'])
          if heads["subject"].include?("complaint about message from ")
            # From: staff@hotmail.com
            # From: complaints@email-abuse.amazonses.com
            # Subject: complaint about message from 192.0.2.1
            return true if AbuseAddrs.any? { |a| cv.include?(a) }
          end
        end

        while true
          # X-Apple-Unsubscribe: true
          break unless heads.has_key?("x-apple-unsubscribe")
          return true if heads["x-apple-unsubscribe"] == "true"
          break
        end
        return false
      end

      # @abstract Detect an error for Feedback Loop
      # @param  [Hash] mhead    Message headers of a bounce email
      # @param  [String] mbody  Message body of a bounce email
      # @return [Hash]          Bounce data list and message/rfc822 part
      # @return [Nil]           it failed to decode or the arguments are missing
      def inquire(mhead, mbody)
        return nil unless self.is_arf(mhead)

        dscontents = [Sisimai::Lhost.DELIVERYSTATUS]
        emailparts = Sisimai::RFC5322.part(mbody, Boundaries)
        bodyslices = emailparts[0].split("\n")
        reportpart = false
        readcursor = 0    # Points the current cursor position
        recipients = 0    # The number of 'Final-Recipient' header
        timestamp0 = ""   # The value of "Arrival-Date" or "Received-Date"
        remotehost = ""   # The value of "Source-IP" field
        reportedby = ""   # The value of "Reporting-MTA" field
        anotherone = ""   # Other fields(append to Diagnosis)
        v = dscontents[-1]

        # 3.1.  Required Fields
        #
        #   The following report header fields MUST appear exactly once:
        #
        #   o  "Feedback-Type" contains the type of feedback report (as defined
        #      in the corresponding IANA registry and later in this memo).  This
        #      is intended to let report parsers distinguish among different
        #      types of reports.
        #
        #   o  "User-Agent" indicates the name and version of the software
        #      program that generated the report.  The format of this field MUST
        #      follow section 14.43 of [HTTP].  This field is for documentation
        #      only; there is no registry of user agent names or versions, and
        #      report receivers SHOULD NOT expect user agent names to belong to a
        #      known set.
        #
        #   o  "Version" indicates the version of specification that the report
        #      generator is using to generate the report.  The version number in
        #      this specification is set to "1".
        #
        while e = bodyslices.shift do
          # This is an email abuse report for an email message with the
          #   message-id of 0000-000000000000000000000000000000000@mx
          #   received from IP address 192.0.2.1 on
          #   Thu, 29 Apr 2010 00:00:00 +0900 (JST)
          if readcursor == 0
            # Beginning of the bounce message or message/delivery-status part
            r = e.downcase
            ARFPreface.each do |f|
              # Hello,
              # this is an autogenerated email abuse complaint regarding your network.
              next unless Sisimai::String.aligned(r, f)
              readcursor |= Indicators[:deliverystatus]
              v["diagnosis"] << " " + e
              break
            end
            next
          end
          next unless readcursor & Indicators[:deliverystatus] > 0
          next if e.empty?
          if e == ReportFrom then reportpart = true; next; end

          if reportpart
            # Feedback-Type: abuse
            # User-Agent: SomeGenerator/1.0
            # Version: 0.1
            # Original-Mail-From: <somespammer@example.net>
            # Original-Rcpt-To: <kijitora@example.jp>
            # Received-Date: Thu, 29 Apr 2009 00:00:00 JST
            # Source-IP: 192.0.2.1
            if e.start_with?("Original-Rcpt-To: ") || e.start_with?("Removal-Recipient: ")
              # Original-Rcpt-To header field is optional and may appear any number of times as appropriate:
              # Original-Rcpt-To: <kijitora@example.jp>
              # Removal-Recipient: user@example.com
              cv = Sisimai::Address.s3s4(e[e.index(" ") + 1, e.size]); next unless Sisimai::Address.is_emailaddress(cv)
              cw = dscontents.size;                                    next if cw > 0 && cv == dscontents[cw - 1]["recipient"]

              if v["recipient"] != ""
                # There are multiple recipient addresses in the message body.
                dscontents << Sisimai::Lhost.DELIVERYSTATUS
                v = dscontents[-1]
              end
              v["recipient"] = cv
              recipients += 1

            elsif e.start_with?("Feedback-Type: ")
              # The header field MUST appear exactly once.
              # Feedback-Type: abuse
              v["feedbacktype"] = e[e.index(" ") + 1, e.size]

            elsif e.start_with?("Authentication-Results: ")
              # "Authentication-Results" indicates the result of one or more authentication checks
              # run by the report generator.
              #
              # Authentication-Results: mail.example.com;
              #   spf=fail smtp.mail=somespammer@example.com
              anotherone << e + ", "

            elsif e.start_with?("User-Agent: ")
              # The header field MUST appear exactly once.
              # User-Agent: SomeGenerator/1.0
              anotherone << e + ", "

            elsif e.start_with?("Received-Date: ") || e.start_with?("Arrival-Date: ")
              # Arrival-Date header is optional and MUST NOT appear more than once.
              # Received-Date: Thu, 29 Apr 2010 00:00:00 JST
              # Arrival-Date: Thu, 29 Apr 2010 00:00:00 +0000
              timestamp0 = e[e.index(" ") + 1, e.size]

            elsif e.start_with?("Reporting-MTA: ")
              # The header is optional and MUST NOT appear more than once.
              # Reporting-MTA: dns; mx.example.jp
              cv = Sisimai::RFC1894.field(e); next if cv.size == 0
              reportedby = cv[2]

            elsif e.start_with?("Source-IP: ")
              # The header is optional and MUST NOT appear more than once.
              # Source-IP: 192.0.2.45
              remotehost = e[e.index(" ") + 1, e.size]

            elsif e.start_with?("Original-Mail-From: ")
              # the header is optional and MUST NOT appear more than once.
              # Original-Mail-From: <somespammer@example.net>
              anotherone << e + ", "
            end
          else
            # Messages before "Content-Type: message/feedback-report" part
            v["diagnosis"] << " " + e
          end

          while recipients == 0
            # There is no recipient address in the message
            if mhead.has_key?("x-apple-unsubscribe")
              # X-Apple-Unsubscribe: true
              last unless mhead["x-apple-unsubscribe"] == "true"
              last unless mhead["from"].include?('@')
              dscontents[0]["recipient"]    = mhead["from"]
              dscontents[0]["diagnosis"]    = Sisimai::String.sweep(emailparts[0])
              dscontents[0]["feedbacktype"] = "opt-out"

              # Addpend To: field as a pseudo header
              emailparts[1] = sprintf("To: <%s>\n", mhead["from"]) if emailparts[1].empty?

            else
              # Pick it from the original message part
              p1 = emailparts[1].index("\nTo:");      break if p1.nil?
              p2 = emailparts[1].index("\n", p1 + 4); break if p2.nil?
              cv = Sisimai::Address.s3s4(emailparts[1][p1 + 4, p2 - p1])

              # There is no valid email address in the To: header of the original message such as
              # To: <Undisclosed Recipients>
              cv = Sisimai::Address.undisclosed("r") unless Sisimai::Address.is_emailaddress(cv)
              dscontents[0]["recipient"] = cv
            end
            recipients += 1
          end
          return nil if recipients == 0

          anotherone = ": " + Sisimai::String.sweep(anotherone) if anotherone != ""
          anotherone = anotherone.chop if anotherone[-1, 1] == ","

          j = -1
          dscontents.each do |e|
            # Tidy up the error message in e.Diagnosis, Try to detect the bounce reason.
            j += 1
            e["diagnosis"] = Sisimai::String.sweep(e["diagnosis"] + anotherone)
            e["reason"]    = "feedback"
            e["rhost"]     = remotehost
            e["lhost"]     = reportedby
            e["date"]      = timestamp0

            # Copy some values from the previous element when the report have 2 or more email address
            next if j == 0 || dscontents.size == 1
            e["diagnosis"]    = dscontents[j - 1]["diagnosis"]
            e["feedbacktype"] = dscontents[j - 1]["feedbacktype"]
          end
        end
        return { "ds" => dscontents, "rfc822" => emailparts[1] }
      end
    end
  end
end

