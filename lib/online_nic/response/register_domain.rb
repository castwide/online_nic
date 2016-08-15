class OnlineNic::Response::RegisterDomain < OnlineNic::Response::Base
  attr_reader :domain, :reg_date, :exp_date
  def post_initialize
    if success?
      @domain = data['domain']
      @reg_date = data['reg_date']
      @exp_date = data['exp_date']
    end
  end
end
