class TodoRemoved
  include Webspicy::Specification::Postcondition

  def self.match(service, descr)
    return TodoRemoved.new if descr =~ /The todo has been removed/
  end

  def check(invocation)
    client = invocation.client
    id = invocation.test_case.params['id']
    url = "/todo/#{id}"
    response = client.api.get(url, {}, {
      "Accept" => "application/json"
    })
    return nil if response.status == 404
    "Todo `#{id}` was not deleted, it has been found"
  end
end
