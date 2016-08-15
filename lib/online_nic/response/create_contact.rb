class OnlineNic::Response::CreateContact < OnlineNice::Response::Base
  attr_reader :contactid
  def post_initialize
    if success?
      @contactid = data['contactid']
    end
  end
end
