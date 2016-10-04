require 'eventmachine'

module OnlineNic
  autoload :DomainExtensions, 'online_nic/domain_extensions'
  autoload :Transaction, 'online_nic/transaction'
  autoload :Response, 'online_nic/response'
  
  def self.check_domain config
    transact OnlineNic::Transaction::CheckDomain, config
  end
  def self.create_contact config
    result = transact OnlineNic::Transaction::CreateContact, config
    result
  end
  def self.register_domain config
    transact OnlineNic::Transaction::RegisterDomain, config
  end
  def self.get_name_servers config
    transact OnlineNic::Transaction::GetNameServers, config
  end
  def self.update_dns config
    transact OnlineNic::Transaction::UpdateDns, config
  end
  def self.get_domain_info config
    transact OnlineNic::Transaction::GetDomainInfo, config
  end
  def self.update_domain_contact config
    transact OnlineNic::Transaction::UpdateDomainContact, config
  end
  def self.get_price config
    transact OnlineNic::Transaction::GetPrice, config
  end
  def self.usermode
    @usermode ||= ENV['ONLINENIC_MODE']
  end
  def self.username
    @username ||= ENV['ONLINENIC_USERNAME']
  end
  def self.password
    @password ||= ENV['ONLINENIC_PASSWORD']
  end
  class << self
    private
    def transact cls, config
      connection = nil
      EventMachine.run do
        login = {}
        if usermode == 'test'
          login[:url] = 'ote.onlinenic.com'
          login[:user] = '135610'
          login[:pass] = '654123'
        else
          login[:url] = 'www.onlinenic.com'
          login[:user] = username
          login[:pass] = password
        end
        connection = EventMachine.connect login[:url], 30009, cls, login[:user], login[:pass], config
      end
      connection.response
    end
  end
end
