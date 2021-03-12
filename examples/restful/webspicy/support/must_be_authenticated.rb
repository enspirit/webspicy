class MustBeAuthenticated
  include Webspicy::Specification::Pre

  def initialize(role = :user)
    @role = role
  end
  attr_reader :role

  def self.match(service, pre)
    MustBeAuthenticated.new if pre =~ /Must be authenticated/
  end

  def instrument
    return if test_case.metadata.has_key?(:role)
    return if test_case.description =~ /When not authenticated at all/
    test_case.metadata[:role] = role
  end

  def counterexamples(service)
    examples = super
    examples << counterexample(
      "When not authenticated at all",
      "~",
      "Please log in first",
      401
    )
    examples
  end

  def counterexample(description, role, expected, status = 401)
    YAML.load <<~YML.gsub(/^\s+[#][ ]/, "")
      description: |-
        #{description} (#{self.class.name} PRE)
      params:
        id: 1
      dress_params:
        false
      metadata:
        role: #{role}
      expected:
        content_type: application/json
        status: #{status}
      assert:
        - "pathFD('', error: '#{expected}')"
    YML
  end

end
