module OnlineNic
  class Transaction::UpdateDns < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      cltrid = create_cltrid
      checksum = create_checksum(cltrid, 'updatedomaindns', domaintype, domain)
      request = '<?xml version="1.0"?> <request> <category>domain</category> <action>UpdateDomainDns</action> <params> <param name="domaintype">' + domaintype + '</param> <param name="domain">' + domain + '</param>'
      config[:nameservers].each { |ns|
        request += '<param name="nameserver">' + ns + '</param>'
      }
      request += '</params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/UpdateDomainDns'
        logout
      else
        raise "Cannot handle response"
      end    
    end
  end
end
