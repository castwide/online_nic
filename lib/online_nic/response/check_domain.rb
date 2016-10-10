class OnlineNic::Response::CheckDomain < OnlineNic::Response::Base
  attr_reader :domain, :price
  
  def post_initialize
    if success?
      @domain = data['domain']
      @available = (data['avail'] == '1') || !data['price'].to_s.empty?
      if !data['price'].nil?
        @price = BigDecimal.new(data['price'])
      end
    end
  end
  def available?
    @available
  end
end
