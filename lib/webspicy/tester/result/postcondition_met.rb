module Webspicy
  class Tester
    class Result
      class PostconditionMet < Check

        def initialize(result, post)
          super(result)
          @post = post
        end
        attr_reader :post

        def behavior
          post.to_s
        end

        def must?
          true
        end

        def call
          post.check!
        end

      end # class PostconditionMet
    end # class Result
  end # class Tester
end # module Webspicy
