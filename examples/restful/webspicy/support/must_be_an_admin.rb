require_relative 'must_be_authenticated'
class MustBeAnAdmin < MustBeAuthenticated
  include Webspicy::Precondition

  def self.match(service, pre)
    MustBeAnAdmin.new(:admin) if pre =~ /Must be an admin/
  end

  def counterexamples(service)
    examples = super
    examples << counterexample(
      "When authenticated as a normal user",
      "user",
      "Admin required",
      401
    )
    examples
  end

end
