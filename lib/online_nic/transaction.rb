module OnlineNic
  module Transaction
    autoload :Base, 'online_nic/transaction/base'
    autoload :CheckDomain, 'online_nic/transaction/check_domain'
    autoload :CreateContact, 'online_nic/transaction/create_contact'
    autoload :RegisterDomain, 'online_nic/transaction/register_domain'
    autoload :GetNameServers, 'online_nic/transaction/get_name_servers'
    autoload :UpdateDns, 'online_nic/transaction/update_dns'
  end
end
