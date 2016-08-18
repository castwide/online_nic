class OnlineNic::Response::GetDomainInfo < OnlineNic::Response::Base
  attr_reader :reg_date, :exp_date, :password, :dns, :registrant, :admin, :technical, :billing
  
  def post_initialize
    if success?
      @reg_date = data['crDate']
      @exp_date = data['exDate']
      @password = data['password']
      @dns = data['dns']
      @registrant = ContactInfo.new(data, 'r')
      @admin = ContactInfo.new(data, 'a')
      @technical = ContactInfo.new(data, 't')
      @billing = ContactInfo.new(data, 't')
    end
  end
  def available?
    @available
  end
  
  class ContactInfo
    attr_reader :name, :org, :country, :province, :city,:address, :postalcode, :telephone, :fax, :email
    def initialize data, prefix
      @name = data["#{prefix}_name"]
      @org = data["#{prefix}_org"]
      @country = data["#{prefix}_country"]
      @province = data["#{prefix}_province"]
      @city = data["#{prefix}_city"]
      @address = data["#{prefix}_address"]
      @postalcode = data["#{prefix}_postalcode"]
      @telephone = data["#{prefix}_telephone"]
      @fax = data["#{prefix}_fax"]
      @email = data["#{prefix}_email"]
    end
  end
end
