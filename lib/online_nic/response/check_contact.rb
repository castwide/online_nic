class OnlineNic::Response::CheckContact < OnlineNic::Response::Base
  attr_reader :contactid
  
  def post_initialize
    if success?
      @contactid = data['contactid']
      @available = (data['avail'] == '1')
    end
  end
  def available?
    @available
  end
end
