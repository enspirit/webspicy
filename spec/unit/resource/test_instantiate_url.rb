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

    it 'instantiates placeholders and strips corresponding params even when multiple' do
      r = Resource.new(url: "/test/{foo}/url/{bar}")
      url, params = r.instantiate_url(foo: "bar", bar: "baz", baz: "coz")
      expect(url).to eq("/test/bar/url/baz")
      expect(params).to eq(baz: "coz")
    end

    it 'supports placeholders corresponding to subentities' do
      r = Resource.new(url: "/test/{foo.id}/url")
      url, params = r.instantiate_url(foo: {id: "bar"}, baz: "coz")
      expect(url).to eq("/test/bar/url")
      expect(params).to eq(foo: {}, baz: "coz")
    end

  end
end
