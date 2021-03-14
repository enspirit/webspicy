require 'spec_helper'
module Webspicy
  class Specification
    describe Service, "dress_params" do

      it 'symbolizes keys' do
        service = Webspicy::Web.service({
          method: "GET",
          description: "Test service",
          preconditions: "Foo",
          input_schema: "{ id: Integer }",
          output_schema: "{}",
          error_schema: "{}"
        })
        params = service.dress_params("id" => 1247)
        expect(params).to eq(id: 1247)
      end

      it 'supports an array' do
        service = Webspicy::Web.service({
          method: "GET",
          description: "Test service",
          preconditions: "Foo",
          input_schema: "[{ id: Integer }]",
          output_schema: "{}",
          error_schema: "{}"
        })
        params = service.dress_params([{"id" => 1247}])
        expect(params).to eq([{id: 1247}])
      end

    end
  end # class Specification
end # module Webspicy
