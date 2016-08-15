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
    puts "**************** RESULT #{result.inspect}"
    result
  end
  def self.register_domain config
    transact OnlineNic::Transaction::RegisterDomain, config
  end
  def self.update_dns config
    transact OnlineNic::Transaction::UpdateDns, config
    #begin
    #  EventMachine.run do
    #    EventMachine.connect 'www.onlinenic.com', 30009, OnlineNic::Transaction::UpdateDns, '589467', 'awaken!allah', config
    #  end
    #  true
    ## TODO This is a bad way to handle this.
    #rescue Exception => e
    #  false
    #end
  end
  class << self
    private
    def transact cls, config
      connection = nil
      EventMachine.run do
        login = {}
        if ENV['ONLINENIC_MODE'] == 'test'
          login[:url] = 'ote.onlinenic.com'
          login[:user] = '135610'
          login[:pass] = '654123'
        else
          login[:url] = 'www.onlinenic.com'
          login[:user] = ENV['ONLINENIC_USERNAME']
          login[:pass] = ENV['ONLINENIC_PASSWORD']
        end
        connection = EventMachine.connect login[:url], 30009, cls, login[:user], login[:pass], config
      end
      connection.response
    end
  end
end
