module OnlineNic
  class Transaction::GetPrice < Transaction::Base
    def process_request
      domain = config[:domain]
      op = config[:op] || 'reg'
      period = config[:period] || 1
      domaintype = DomainExtensions.get_type(domain)
      request = create_request 'domain', 'GetDomainPrice'
      request.add_param 'domaintype', domaintype
      request.add_param 'domain', domain
      request.add_param 'op', op
      request.add_param 'period', period
      request.set_checksum 'getdomainprice', domaintype, domain, op, period
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
