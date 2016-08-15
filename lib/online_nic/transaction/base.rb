require 'rexml/document'

module OnlineNic
  class Transaction::Base < EventMachine::Connection
    #attr_reader :config, :document
    attr_reader :config
    
    def initialize username, password, config
      @username = username
      @password = password
      @config = config
      @logged_in = false
      @logging_out = false
      @document = nil
      super
    end
    def receive_data(data)
      puts "***************** RECEIVED #{data}"
      #if code >= 2000
      #  puts data
      #  raise doc.root.elements['msg'].text
      #end
      #@document = doc
      #if @logged_in and !@logging_out
      #  process_response
      #else
      #  process_base
      #end
      #@response = OnlineNic::Response::Base.new(doc)
      # The Base class always handles logging in and out
      if @logged_in and !@logging_out
        @document = REXML::Document.new(data)
        process_response
      else
        original = @document
        @document = REXML::Document.new(data)
        process_base
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
        cltrid = create_cltrid
        checksum = create_checksum(cltrid, 'login')
        request = '<?xmlversion="1.0" encoding="UTF-8" standalone="no"?> <request> <category>client</category> <action>Login</action> <params> <param name="clid">' + @username + '</param> </params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
        send_data request
      when 'client/Login'
        @logged_in = true
        process_request
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
    def get_action
      category = document.root.elements['category'].text
      action = document.root.elements['action'].text
      "#{category}/#{action}"
    end
    def logout
      @logging_out = true
      cltrid = create_cltrid
      checksum = create_checksum(cltrid, 'logout')
      request = '<?xmlversion="1.0" encoding="UTF-8" standalone="no"?> <request> <category>client</category> <action>Logout</action> <params> <param name="clid">' + @username + '</param> </params> <cltrid>' + cltrid + '</cltrid> <chksum>' + checksum + '</chksum> </request>'
      send_data request
    end
    protected
    def document
      @document
    end
    def set_response response_object
      @response = response_object
    end
  end
end
