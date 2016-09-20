module OnlineNic
  class Transaction::CheckDomain < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      request = create_request 'domain', 'CheckDomain'
      request.add_param 'domaintype', domaintype
      request.add_param 'domain', domain
      request.set_checksum('checkdomain', domaintype, domain)
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/CheckDomain'
        response = OnlineNic::Response::CheckDomain.new(document)
        if response.available? and config[:with_price]
          domain = config[:domain]
          domaintype = DomainExtensions.get_type(domain)
          request = create_request 'domain', 'GetDomainPrice'
          request.add_param 'domaintype', domaintype
          request.add_param 'domain', domain
          request.add_param 'op', 'reg'
          request.add_param 'period', 1
          request.set_checksum 'getdomainprice', domaintype, domain, 'reg', 1
          send_data request
        else
          set_response response
          logout
        end
      elsif action == 'domain/GetDomainPrice'
        set_response OnlineNic::Response::CheckDomain.new(document)
        logout
      else
        raise "Unable to handle action #{action}"
      end    
    end
  end
end
