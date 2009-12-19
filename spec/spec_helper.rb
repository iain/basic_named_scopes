$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'basic_named_scopes'
require 'spec'
require 'spec/autorun'
require 'active_record'
require 'temping'

Spec::Runner.configure do |config|
  config.include(Temping)
end

def be_scope
  eql(ActiveRecord::NamedScope::Scope)
end
