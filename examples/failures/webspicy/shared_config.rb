def webspicy_config(*args, &bl)
  Webspicy::Configuration.new(*args) do |c|
    c.client = Webspicy::Web::RackTestClient.for(::Sinatra::Application)
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
