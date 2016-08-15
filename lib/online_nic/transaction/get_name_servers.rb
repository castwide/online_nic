module OnlineNic
  # This transaction will return the host names assigned to the domain.
  
  class Transaction::GetNameServers < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      cltrid = create_cltrid
      checksum = create_checksum(cltrid, 'infohost', domaintype, domain)
      request = '<?xml version="1.0"?> <request> <category>domain</category> <action>InfoHost</action> <params> <param name="domaintype">' + domaintype + '</param> <param name="hostname">' + domain + '</param> </params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
      puts request
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
