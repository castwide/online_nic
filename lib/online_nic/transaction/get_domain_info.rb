module OnlineNic
  class Transaction::GetDomainInfo < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      cltrid = create_cltrid
      checksum = create_checksum(cltrid, 'infodomain', domaintype, domain)
      request = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?><request><category>domain</category><action>InfoDomain</action><params><param name="domaintype">' + domaintype + '</param><param name="domain">' + domain + '</param></params><cltrid>' + cltrid + '</cltrid><chksum>' + checksum + '</chksum></request>'
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/InfoDomain'
        set_response OnlineNic::Response::GetDomainInfo.new(document)
        logout
      else
        raise "Unexpected action #{action}"
      end    
    end
  end
end
