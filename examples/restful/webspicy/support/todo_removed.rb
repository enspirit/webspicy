class TodoRemoved
  include Webspicy::Specification::Post

  def self.match(service, descr)
    return TodoRemoved.new if descr =~ /The todo has been removed/
  end

  def check!
    id = test_case.params['id']
    url = scope.to_real_url("/todo/#{id}", test_case){|url| url }
    response = client.api.get(url, {}, {
      "Accept" => "application/json"
    })
    return nil if response.status == 404

    fail!("Todo `#{id}` was not deleted, it has been found")
  end
end
