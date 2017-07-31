require 'rspec'
require 'webspicy'

module SpecHelper

  def examples_folder
    Webspicy::EXAMPLES_FOLDER
  end

  def restful_folder
    examples_folder/'restful/webspicy'
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
