class OnlineNic::Response::GetPrice < OnlineNic::Response::Base
  attr_reader :domain, :price
  
  def post_initialize
    if success?
      @domain = data['domain']
      @price = BigDecimal.new(data['price'])
    end
  end
end
