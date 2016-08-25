module OnlineNic
  class Transaction::UpdateDomainContact < Transaction::Base
    def process_request
      cltrid = create_cltrid
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      password = 'password12345' # TODO generate random or require in config
      checksum = create_checksum(cltrid, 'updatecontact', domaintype, config[:domain].to_s, config[:contacttype])
      request = '<?xml verions="1.0" encoding="UTF-8" standalone="no" ?><request><category>domain</category><action>UpdateContact</action><params> <param name="domaintype">' + domaintype.to_s + '</param><param name="domain">' + config[:domain].to_s + '</param><param name="contacttype">'+ config[:contacttype].to_s + '</param>'
      if config[:contacttype] != 'registrant'
        request += '<param name="name">' + config[:name].to_s + '</param>'
      end
      request += '<param name="org">' + config[:org].to_s + '</param> <param name="country">' + config[:country].to_s + '</param> <param name="province">' + config[:province].to_s + '</param> <param name="city">' + config[:city].to_s + '</param> <param name="street">' + config[:street].to_s + '</param> <param name="postalcode">' + config[:postalcode].to_s + '</param> <param name="voice">' + config[:voice].to_s + '</param> <param name="fax">' + config[:fax].to_s + '</param> <param name="email">' + config[:email].to_s + '</param> <param name="password">' + password.to_s + '</param> </params> <cltrid>' + cltrid.to_s + '</cltrid> <chksum>' + checksum.to_s + '</chksum> </request>'
      puts request
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
