class OnlineNic::Response::GetPrice < OnlineNic::Response::Base
  attr_reader :domain, :price
  
  def post_initialize
    if success?
      @domain = data['domain']
      @price = data['price'].to_f
    end
  end
end
