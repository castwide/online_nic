class OnlineNic::Response::Base
  attr_reader :document, :data, :error
  
  def initialize document
    @document = document
    @data = {}
    if success?
      parse_response_data
      post_initialize
    else
      process_error
    end
  end
  # Subclasses can override this class to process response data, etc.
  # It does not get called if the response is not successful.
  def post_initialize
    # Base class does nothing
  end
  # @return [Boolean]
  def success?
    @success ||= document.root.elements['code'].text.to_i
    @success < 2000
  end
  private
  def process_error
    @error = "#{document.root.elements['msg'].text} (#{document.root.elements['value'].text})"
  end
  def parse_response_data
    document.elements.each('response/resData/data') { |element|
      @data[element.attributes['name']] = element.text
    }
  end
end
