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
      domain = config[:domain].to_s
      domaintype = DomainExtensions.get_type(domain)
      period = config[:period].to_s
      dns1 = config[:dns1].to_s
      dns2 = config[:dns2].to_s
      registrant = config[:registrant].to_s
      admin = config[:admin].to_s
      tech = config[:tech].to_s
      billing = config[:billing].to_s
      # ced required for ASIA registration. See Online NIC API reference
      password = 'password12345' # TODO Generate a password
      request = create_request 'domain', 'CreateDomain'
      request.add_param 'domaintype', domaintype
      request.add_param 'mltype', '0'
      request.add_param 'domain', domain
      request.add_param 'period', period
      request.add_param 'dns', dns1
      request.add_param 'dns', dns2
      request.add_param 'registrant', registrant
      request.add_param 'tech', tech
      request.add_param 'billing', billing
      request.add_param 'admin', admin
      request.add_param 'password', password
      request.set_checksum 'createdomain', domaintype, domain, period, dns1, dns2, registrant, admin, tech, billing, password
      send_data request
    end
    def process_response
      action = get_action
      if action == 'domain/CreateDomain'
        set_response OnlineNic::Response::RegisterDomain.new(document)
        logout
      else
        raise "Invalid response"
      end
    end
  end
end
