class FailingCondition
  include Webspicy::Specification::Post
  include Webspicy::Specification::Err

  def self.match(service, descr)
    return FailingCondition.new if descr =~ /Failing (post|err)condition$/
  end

  def check!
    fail!("It is not met")
  end

end
