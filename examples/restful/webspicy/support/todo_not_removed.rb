class TodoNotRemoved
  include Webspicy::Specification::Postcondition

  def self.match(service, descr)
    return TodoNotRemoved.new if descr =~ /If it existed, the todo has not been removed/
  end

  def check(invocation)
    return if invocation.response.status == 404
    client, test_case = invocation.client, invocation.test_case

    res = client.find_and_call("GET", "/todo/{id}", {
      params: { "id" => test_case.params['id'] },
    }).response
    return nil if res.status == 200

    "Todo `#{id}` was not supposed to be deleted, it was not found"
  end
end
