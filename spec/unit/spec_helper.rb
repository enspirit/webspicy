require 'rspec'
require 'webspicy'

module SpecHelper

  def restful_folder
    Webspicy::EXAMPLES_FOLDER/'restful/webspicy'
  end

end

module ScopeManagement

  def with_scope_management
    before(:each) {
      Webspicy.set_current_scope(scope)
    }
    after(:each) {
      Webspicy.set_current_scope(nil)
    }
  end

end

RSpec.configure do |c|
  c.include SpecHelper
  c.extend  ScopeManagement
end
