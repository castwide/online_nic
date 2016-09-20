module OnlineNic
  class Transaction::UpdateDomainContact < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      password = 'password12345' # TODO generate random or require in config
      request = create_request 'domain', 'UpdateContact'
      request.add_param 'domaintype', domaintype
      request.add_param 'domain', domain
      request.add_param 'contacttype', config[:contacttype]
      if config[:contacttype] != 'registrant'
        request.add_param 'name', config[:name]
      end
      request.add_param 'org', config[:org]
      request.add_param 'country', config[:country]
      request.add_param 'province', config[:province]
      request.add_param 'city', config[:city]
      request.add_param 'street', config[:street]
      request.add_param 'postalcode', config[:postalcode]
      request.add_param 'voice', config[:voice]
      request.add_param 'fax', config[:fax]
      request.add_param 'email', config[:email]
      request.add_param 'password', password
      request.set_checksum 'updatecontact', domaintype, domain, config[:contacttype]
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/UpdateContact'
        logout
      else
        raise "Failed to handle action #{action}"
      end
    end
  end
end
