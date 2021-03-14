module Webspicy
  class Specification
    include Support::DataObject

    def initialize(raw, location = nil)
      super(raw)
      @location = location
      bind_services
    end
    attr_accessor :config
    attr_reader :location

    def located_at!(location)
      @location = Path(location)
    end

    def locate(relative_path)
      file = @location.parent/relative_path
      raise "File not found: #{file}" unless file.exists?
      file
    end

    def name
      @raw[:name]
    end

    def services
      @raw[:services] || []
    end

  private

    def bind_services
      services.each do |s|
        s.specification = self
      end
    end

  end # class Specification
end # module Webspicy
require_relative 'specification/service'
require_relative 'specification/condition'
require_relative 'specification/pre'
require_relative 'specification/post'
require_relative 'specification/err'
require_relative 'specification/oldies'
require_relative 'specification/test_case'
