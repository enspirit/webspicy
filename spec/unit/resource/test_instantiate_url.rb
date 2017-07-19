require "spec_helper"
module Webspicy
  describe Resource, "instantiate_url" do

    it 'does nothing when the url has no placeholder' do
      r = Resource.new(url: "/test/a/url")
      url, params = r.instantiate_url(foo: "bar")
      expect(url).to eq("/test/a/url")
      expect(params).to eq(foo: "bar")
    end

    it 'instantiates placeholders and strips corresponding params' do
      r = Resource.new(url: "/test/{foo}/url")
      url, params = r.instantiate_url(foo: "bar", baz: "coz")
      expect(url).to eq("/test/bar/url")
      expect(params).to eq(baz: "coz")
    end

  end
end
