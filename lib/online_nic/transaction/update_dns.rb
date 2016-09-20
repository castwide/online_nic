module OnlineNic
  class Transaction::UpdateDns < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      request = create_request 'domain', 'UpdateDomainDns'
      request.add_param 'domaintype', domaintype
      request.add_param 'domain', domain
      config[:nameservers].each { |ns|
        request.add_param 'nameserver', ns
      }
      request.set_checksum 'updatedomaindns', domaintype, domain
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/UpdateDomainDns'
        logout
      else
        raise "Unexpected action #{action}"
      end    
    end
  end
end
