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

RSpec.configure do |c|
  c.include SpecHelper
end
