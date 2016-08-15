module OnlineNic
  # Register a domain.
  # Config data:
  #   domain: the domain name
  #   period: the number of years to register
  #   dns1: domain name server
  #   dns2: domain name server
  #   registrant: the ID of the registrant contact record
  #   admin: the ID of the admin contact record
  #   tech: the ID of the tech contact record
  #   billing: the ID of the billing contact record
  #
  class Transaction::RegisterDomain < Transaction::Base
    def process_request
      cltrid = create_cltrid
      domain = config[:domain].to_s
      domaintype = DomainExtensions.get_type(domain)
      period = config[:period].to_s
      dns1 = config[:dns1].to_s
      dns2 = config[:dns2].to_s
      registrant = config[:registrant].to_s
      admin = config[:admin].to_s
      tech = config[:tech].to_s
      billing = config[:billing].to_s
      # ced required for ASIA registration
      password = 'password12345' # TODO Generate a password
      checksum = create_checksum(cltrid, 'createdomain', domaintype, domain, period, dns1, dns2, registrant, admin, tech, billing, password)
      request = '<request> <category>domain</category> <action>CreateDomain</action> <params> <param name="domaintype">' + domaintype + '</param> <param name="mltype">0</param> <param name="domain">' + domain + '</param> <param name="period">' + period + '</param> <param name="dns">' + dns1 + '</param> <param name="dns">' + dns2 + '</param> <param name="registrant">' + registrant + '</param> <param name="tech">' + tech + '</param> <param name="billing">' + billing + '</param> <param name="admin">' + admin + '</param> <param name="password">' + password + '</param> </params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
      puts request
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/CreateDomain'
        document.elements.each('response/resData/data') { |element|
          result[element.attributes['name']] = element.text
        }
        logout
      else
        raise "Invalid response"
      end
    end
  end
end
