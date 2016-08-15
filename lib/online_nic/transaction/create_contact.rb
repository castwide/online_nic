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
      cltrid = create_cltrid
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      password = 'password12345' # TODO generate random or require in config
      checksum = create_checksum(cltrid, 'crtcontact', config[:name].to_s, config[:org].to_s, config[:email].to_s)
      request = '<request> <category>domain</category> <action>CreateContact</action> <params> <param name="domaintype">' + domaintype.to_s + '</param> <param name="name">' + config[:name].to_s + '</param> <param name="org">' + config[:org].to_s + '</param> <param name="country">' + config[:country].to_s + '</param> <param name="province">' + config[:province].to_s + '</param> <param name="city">' + config[:city].to_s + '</param> <param name="street">' + config[:street].to_s + '</param> <param name="postalcode">' + config[:postalcode].to_s + '</param> <param name="voice">' + config[:voice].to_s + '</param> <param name="fax">' + config[:fax].to_s + '</param> <param name="email">' + config[:email].to_s + '</param> <param name="password">' + password.to_s + '</param> </params> <cltrid>' + cltrid.to_s + '</cltrid> <chksum>' + checksum.to_s + '</chksum> </request>'
      puts request
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
