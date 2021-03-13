class SucceedingCondition
  include Webspicy::Specification::Post
  include Webspicy::Specification::Err

  def self.match(service, descr)
    return SucceedingCondition.new if descr =~ /Succeeding (post|err)condition$/
  end

  def check!
    "Is is met"
  end

end
