class TodoNotRemoved
  include Webspicy::Specification::Postcondition

  def self.match(service, descr)
    return TodoNotRemoved.new if descr =~ /If it existed, the todo has not been removed/
  end

  def check(invocation)
    client, scope, test_case = invocation.client,
                               invocation.client.scope,
                               invocation.test_case
    return if invocation.response.status == 404
    id = test_case.params['id']
    url = scope.to_real_url("/todo/#{id}", test_case){|url| url }
    response = client.api.get(url, {}, {
      "Accept" => "application/json"
    })
    return nil if response.status == 200
    "Todo `#{id}` was not supposed to be deleted, it was not found"
  end
end
