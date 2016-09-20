module OnlineNic
  # Create a contact record. The record's ID is used when registering domains
  # to provide the domain's contacts.
  # Config data:
  #   domain: the domain for which the contact info will be created. (This is
  #     necessary to calculate the domain type, which affects the information
  #     required by the record.)
  #   name: the contact's name
  #   org: the contact's organization
  #   country
  #   province
  #   city
  #   street
  #   postalcode
  #   voice: the contact's phone number
  #   fax
  #   email
  #
  class Transaction::CreateContact < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      password = 'password12345' # TODO generate random or require in config
      request = create_request 'domain', 'CreateContact'
      request.add_param 'domaintype', domaintype
      request.add_param 'name', config[:name]
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
      request.set_checksum 'crtcontact', config[:name], config[:org], config[:email]
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/CreateContact'
        set_response OnlineNic::Response::CreateContact.new(document)
        logout
      else
        raise "Failed to handle action #{action}"
      end
    end
  end
end
