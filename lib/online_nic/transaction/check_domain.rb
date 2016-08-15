module OnlineNic
  class Transaction::CheckDomain < Transaction::Base
    def process_request
      domain = config[:domain]
      domaintype = DomainExtensions.get_type(domain)
      cltrid = create_cltrid
      checksum = create_checksum(cltrid, 'checkdomain', domaintype, domain)
      request = '<?xmlversion="1.0"?> <request> <category> domain</category> <action> CheckDomain </action> <params> <param name="domaintype">' + domaintype + '</param> <param name="domain">' + domain + '</param> </params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/CheckDomain'
        parse_result
        if config[:with_price]
          domain = config[:domain]
          domaintype = DomainExtensions.get_type(domain)
          cltrid = create_cltrid
          checksum = create_checksum(cltrid, 'getdomainprice', domaintype, domain, 'reg', 1)
          request = '<request> <category>domain</category> <action>GetDomainPrice</action> <params> <param name="domaintype">' + domaintype + '</param> <param name="domain">' + domain + '</param> <param name="op">reg</param> <param name="period">1</param> </params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
          send_data request
        else
          logout
        end
      elsif action == 'domain/GetDomainPrice'
        parse_result
        logout
      else
        raise "Cannot handle response"
      end    
    end
  end
end
