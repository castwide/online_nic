$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require 'online_nic/version'

Gem::Specification.new do |s|
  s.name        = 'online_nic'
  s.version     = OnlineNic::VERSION
  s.date        = Date.today.strftime("%Y-%m-%d")
  s.summary     = "OnlineNIC library"
  s.description = "A Ruby gem for processing OnlineNIC transactions"
  s.authors     = ["Fred Snyder"]
  s.email       = 'admin@castwide.com'
  s.files       = Dir['lib']
  s.homepage    = 'http://castwide.com'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.9.3'
  s.add_runtime_dependency 'eventmachine'
end
