require 'rspec/expectations'

RSpec::Matchers.define :match_response_status do |expected|
  match do |actual|
    expected === actual
  end
  failure_message_for_should do |actual|
    "expected response status #{actual} to be #{expected}"
  end
end

RSpec::Matchers.define :have_no_response_type do
  match do |actual|
    actual.nil?
  end
  failure_message_for_should do |actual|
    "expected Content-Type not to be present"
  end
end

RSpec::Matchers.define :match_content_type do |expected|
  match do |actual|
    actual.to_s.start_with?(expected.to_s)
  end
  failure_message_for_should do |actual|
    "expected Content-Type to be `#{expected}`, got `#{actual}`"
  end
end

RSpec::Matchers.define :be_in_response_headers do |header_name|
  match do |actual|
    !actual.nil?
  end
  failure_message_for_should do |actual|
    "expected response header `#{header_name}` to be set"
  end
end

RSpec::Matchers.define :match_response_header do |header_name, expected|
  match do |actual|
    expected == actual
  end
  failure_message_for_should do |actual|
    "expected response header `#{header_name}` to be `#{expected}`, got `#{actual}`"
  end
end

RSpec::Matchers.define :be_an_empty_response_body do
  match do |actual|
    actual.empty?
  end
  failure_message_for_should do |actual|
    "expected response body to be empty, started with `#{actual[0..20]}`"
  end
end

RSpec::Matchers.define :meet_output_schema do
  match do |actual|
    !actual.is_a?(Exception)
  end
  failure_message_for_should do |actual|
    "expected response body to meet output schema, got following error:\n" + \
    "    #{actual.message}"
  end
end

RSpec::Matchers.define :meet_error_schema do
  match do |actual|
    !actual.is_a?(Exception)
  end
  failure_message_for_should do |actual|
    "expected response body to meet error schema, got following error:\n" + \
    "    #{actual.message}"
  end
end

RSpec::Matchers.define :meet_assertion do |assert|
  match do |actual|
    actual.nil?
  end
  failure_message_for_should do |actual|
    "expected assertion `#{assert}` to be met, got following error:\n" + \
    "    #{actual.message}"
  end
end

RSpec::Matchers.define :meet_postcondition do |post|
  match do |actual|
    actual.nil?
  end
  failure_message_for_should do |actual|
    "expected postcondition `#{post.class.name}` to be met, got following error:\n" + \
    "    #{actual}"
  end
end

RSpec::Matchers.define :be_an_empty_errors_array do
  match do |actual|
    actual.empty?
  end
  failure_message_for_should do |actual|
    "expected no webspicy error, got the following ones:\n" + actual.map{|a| "    #{a}" }.join("\n")
  end
end
