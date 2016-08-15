class OnlineNic::Response::CreateContact < OnlineNic::Response::Base
  attr_reader :contactid
  def post_initialize
    if success?
      @contactid = data['contactid']
    end
  end
end
