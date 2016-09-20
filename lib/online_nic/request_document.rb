require 'rexml/document'

module OnlineNic
  class RequestDocument < REXML::Document
    def initialize username, password, category, action
      @username = username
      @password = password
      super '<?xml version="1.0" encoding="UTF-8" standalone="no" ?><request/>'
      cat =root.add_element('category')
      cat.text = category
      act = root.add_element('action')
      act.text = action
      clt = root.add_element('cltrid')
      clt.text = cltrid
      root.add_element('chksum')
      root.add_element('params')
    end
    def add_param name, value
      param = root.elements['params'].add_element('param')
      param.attributes['name'] = name
      param.text = value
    end
    def set_checksum *params
      root.elements['chksum'].text = Digest::MD5.hexdigest(@username + Digest::MD5.hexdigest(@password) + cltrid + params.join(''))
    end
    private
    def cltrid
      @cltrid ||= Digest::MD5.hexdigest(Time.now.to_s + rand.to_s)[0..32]
    end
  end
end
