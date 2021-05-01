class OurOwnClient < Webspicy::Web::RackTestClient

  def initialize(scope)
    super(scope, ::Sinatra::Application)
  end

  def _call(test_case)
    if test_case.specification.url =~ /failing-host/
      raise "Unable to access host"
    else
      super(test_case)
    end
  end

end

def webspicy_config(*args, &bl)
  Webspicy::Configuration.new(*args) do |c|
    c.client = OurOwnClient

    c.postcondition SucceedingCondition
    c.errcondition SucceedingCondition
    c.postcondition FailingCondition
    c.errcondition FailingCondition
    c.postcondition DeprecatedFailingCondition
    c.errcondition DeprecatedFailingCondition
    c.postcondition DeprecatedSucceedingCondition
    c.errcondition DeprecatedSucceedingCondition

    bl.call(c)
  end
end
