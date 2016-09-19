module OnlineNic
  class Transaction::GetPrice < Transaction::Base
    def process_request
      domain = config[:domain]
      op = config[:op]
      domaintype = DomainExtensions.get_type(domain)
      cltrid = create_cltrid
      checksum = create_checksum(cltrid, 'getdomainprice', domaintype, domain, op, 1)
      request = '<request> <category>domain</category> <action>GetDomainPrice</action> <params> <param name="domaintype">' + domaintype + '</param> <param name="domain">' + domain + '</param> <param name="op">' + op + '</param> <param name="period">1</param> </params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/GetDomainPrice'
        response = OnlineNic::Response::GetPrice.new(document)
        set_response OnlineNic::Response::CheckDomain.new(document)
        logout
      else
        raise "Unable to handle action #{action}"
      end    
    end
  end
end
