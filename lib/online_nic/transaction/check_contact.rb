module OnlineNic
  class Transaction::CheckContact < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      password = 'password12345' # TODO generate random or require in config
      request = create_request 'domain', 'CheckContact'
      request.add_param 'domaintype', domaintype
      request.add_param 'contactid', config[:contactid]
      request.set_checksum 'checkcontact', domaintype, config[:contactid]
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/CheckContact'
        set_response OnlineNic::Response::Base.new(document)
        logout
      else
        raise "Failed to handle action #{action}"
      end
    end
  end
end
