module Webspicy
  module Support
    class DeepMerge
      class << self

        def symbolize_keys(arg)
          case arg
          when Hash
            arg.each_pair.each_with_object({}){|(k,v),memo|
              memo[k.to_sym] = symbolize_keys(v)
            }
          when Array
            arg.map{|item| symbolize_keys(item) }
          else
            arg
          end
        end

        def deep_merge(h1, h2)
          merge_maps(deep_dup(h1), deep_dup(h2))
        end

        def deep_dup(x)
          case x
          when Array
            x.map{|y| deep_dup(y) }
          when Hash
            x.each_with_object({}){|(k,v),memo| memo[k] = deep_dup(v) }
          else
            x
          end
        end

        private

        def merge_maps(h1, h2)
          h1.merge(h2) do |k,v1,v2|
            case v1
            when Hash  then merge_maps(v1, v2)
            when Array then v1 + v2
            else v2
            end
          end
        end

      end
    end
  end
end
