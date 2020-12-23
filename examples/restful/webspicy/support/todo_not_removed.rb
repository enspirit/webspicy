class TodoNotRemoved
  include Webspicy::Specification::Postcondition

  def self.match(service, descr)
    return TodoNotRemoved.new if descr =~ /If it existed, the todo has not been removed/
  end

  def check(invocation)
    return if invocation.response.status == 404
    client = invocation.client
    id = invocation.test_case.params['id']
    url = "/todo/#{id}"
    response = client.api.get(url, {}, {
      "Accept" => "application/json"
    })
    return nil if response.status == 200
    "Todo `#{id}` was not supposed to be deleted, it was not found"
  end
end
