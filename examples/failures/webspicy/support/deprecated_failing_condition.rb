class DeprecatedFailingCondition
  # include Webspicy::Specification::Postcondition
  # include Webspicy::Specification::Errcondition

  def self.match(service, descr)
    return DeprecatedFailingCondition.new if descr =~ /Failing (post|err)condition \(deprecated\)$/
  end

  def check(invocation)
    "Is is not met (deprecated protocol)"
  end

end
