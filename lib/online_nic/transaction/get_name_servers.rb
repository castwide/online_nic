module OnlineNic
  # This transaction will return the host names assigned to the domain.
  
  class Transaction::GetNameServers < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      request = create_request 'domain', 'InfoHost'
      request.add_param 'domaintype', domaintype
      request.add_param 'hostname', domain
      request.set_checksum 'infohost', domaintype, domain
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/InfoHost'
        logout
      else
        raise "Cannot handle response"
      end    
    end
  end
end
