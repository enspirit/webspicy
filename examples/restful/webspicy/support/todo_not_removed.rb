class TodoNotRemoved
  include Webspicy::Specification::Post

  def self.match(service, descr)
    return TodoNotRemoved.new if descr =~ /If it existed, the todo has not been removed/
  end

  def check!
    return if invocation.response.status == 404

    res = tester.find_and_call("GET", "/todo/{id}", {
      params: { "id" => test_case.params['id'] },
    }).response
    return nil if res.status == 200

    fail!("Todo `#{id}` was not supposed to be deleted, it was not found")
  end
end
