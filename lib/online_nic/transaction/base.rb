require 'rexml/document'

module OnlineNic
  class Transaction::Base < EventMachine::Connection
    include OnlineNic::Transaction::Helpers
    attr_reader :config
    
    def initialize username, password, config
      @username = username
      @password = password
      @config = config
      @logged_in = false
      @logging_out = false
      @document = nil
      @cache = ''
      super
    end
    def receive_data(data)
      @cache += data
      if @logged_in and !@logging_out
        begin
	        @document = REXML::Document.new(@cache)
	        process_response
	        @cache = ''
	      rescue REXML::ParseException => e
          # Wait for more data
	      end
      else
        # The Base class always handles logging in and out
        original = @document
        begin
	        @document = REXML::Document.new(@cache)
	        process_base
	        @cache = ''
	      rescue REXML::ParseException => e
          # Wait for more data
	      end
        @document = original
      end
    end
    def process_request
      logout
    end
    def process_response
      action = get_action
      if action == 'client/Logout'
        close_connection
        EventMachine.stop
      else
        raise "Unexpected action #{action}"
      end
    end
    def process_base
      action = get_action
      case action
      when 'client/Greeting'
        request = create_request 'client', 'Login'
        request.add_param 'clid', @username
        request.set_checksum 'login'
        send_data request
      when 'client/Login'
        response = OnlineNic::Response::Base.new(document)
        if response.success?
	        @logged_in = true
	        process_request
        else
          set_response response
          EventMachine.stop
        end
      when 'client/Logout'
        EventMachine.stop
      else
        raise "Failed to handle action #{action}"
      end
    end
    def response
      @response ||= OnlineNic::Response::Base.new document
    end
    def create_cltrid
      Digest::MD5.hexdigest(Time.now.to_s + rand.to_s)[0..32]
    end
    def create_checksum(cltrid, *params)
      Digest::MD5.hexdigest(@username + Digest::MD5.hexdigest(@password) + cltrid + params.join(''))
    end
    def logout
      @logging_out = true
      request = create_request 'client', 'Logout'
      request.add_param 'clid', @username
      request.set_checksum 'logout'
      send_data request
    end
    protected
    def document
      @document
    end
    def create_request category, action
      RequestDocument.new @username, @password, category, action
    end
    def set_response response_object
      @response = response_object
    end
  end
end
