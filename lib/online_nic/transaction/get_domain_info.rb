module OnlineNic
  class Transaction::GetDomainInfo < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      request = create_request 'domain', 'InfoDomain'
      request.add_param 'domaintype', domaintype
      request.add_param 'domain', domain
      request.set_checksum 'infodomain', domaintype, domain
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
