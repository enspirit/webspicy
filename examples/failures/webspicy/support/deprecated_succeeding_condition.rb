class DeprecatedSucceedingCondition
  # include Webspicy::Specification::Postcondition
  # include Webspicy::Specification::Errcondition

  attr_accessor :matching_description
  alias :to_s :matching_description

  def self.match(service, descr)
    return DeprecatedSucceedingCondition.new if descr =~ /Succeeding (post|err)condition \(deprecated\)$/
  end

  def check(invocation)
    nil
  end

end
