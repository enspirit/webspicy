require "spec_helper"
module Webspicy
  describe Resource, "url_placeholders" do

    it 'returns an empty array on none' do
      r = Resource.new(url: "/test/a/url")
      expect(r.url_placeholders).to eq([])
    end

    it 'returns all placeholders' do
      r = Resource.new(url: "/test/{foo}/url/{bar}")
      expect(r.url_placeholders).to eq([:foo, :bar])
    end

  end
end
