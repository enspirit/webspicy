module Webspicy
  class Tester
    class Reporter
      class JunitXmlFile < Reporter

        TPL = <<~XML
          <?xml version="1.0" encoding="UTF-8"?>
          <testsuites
            disabled="{{counts.disabled}}"
            errors="{{counts.errors}}"
            failures="{{counts.failures}}"
            tests="{{counts.total}}"
            time="{{time}}s"
          >
            {{#testsuites}}
              <testsuite
                name="{{name}}"
                tests="{{counts.total}}"
                errors="{{counts.errors}}"
                failures="{{counts.failures}}"
                time="{{time}}s"
              >
                {{#testcases}}
                  <testcase
                    name="{{name}}"
                    assertions="{{assert}}"
                    classname="{{classname}}"
                    status=""
                    time="{{time}}s"
                  >
                    {{#errors}}
                      <error
                        message="{{message}}"
                        type="{{type}}"
                      ></error>
                    {{/errors}}
                    {{#failures}}
                      <failure
                        message="{{message}}"
                        type="{{type}}"
                        ></failure>
                    {{/failures}}
                  </testcase>
                {{/testcases}}
              </testsuite>
            {{/testsuites}}
          </testsuites>
        XML

        def initialize(path_or_io = STDOUT)
          @path_or_io = path_or_io
          path_or_io.parent.mkdir_p if path_or_io.is_a?(Path)
        end

        attr_reader :template_data, :timer_all, :timer_specification, :timer_testcase

        def before_all
          @timer_all = Time.now
          @template_data = OpenStruct.new({
            counts: Hash.new{|h,k| h[k] = 0 },
            testsuites: []
          })
        end

        def after_all
          template_data.time = Time.now - timer_all
        end

        def before_specification
          @timer_specification = Time.now
          template_data.testsuites << OpenStruct.new({
            :name => specification.name,
            :counts => Hash.new{|h,k| h[k] = 0 },
            :testcases => []
          })
        end

        def specification_done
          template_data.testsuites[-1].time = Time.now - timer_specification
        end

        def spec_file_error(e)
          template_data.testsuites[-1].testcases << OpenStruct.new({
            :name => "Specification can be loaded",
            :assert => 1,
            :classname => "Webspicy.Specification",
            :failures => [],
            :errors => [OpenStruct.new({
              :type => e.class,
              :message => e.message
            })]
          })
        end

        def before_test_case
          @timer_testcase = Time.now
          template_data.testsuites[-1].testcases << OpenStruct.new({
            :name => test_case.description,
            :assert => test_case.assert.length,
            :classname => test_case.class.name.to_s.gsub(/::/, "."),
            :failures => [],
            :errors => [],
          })
          template_data.counts[:total] += 1
          template_data.testsuites[-1].counts[:total] += 1
        end

        def test_case_done
          template_data.testsuites[-1].testcases[-1].time = Time.now - timer_testcase
        end

        def check_failure(check, ex)
          template_data.testsuites[-1].testcases[-1].failures << OpenStruct.new({
            :type => check.class.name,
            :message => ex.message
          })
          template_data.counts[:failures] += 1
          template_data.testsuites[-1].counts[:failures] += 1
        end

        def check_error(check, ex)
          template_data.testsuites[-1].testcases[-1].errors << OpenStruct.new({
            :type => check.class.name,
            :message => ex.message
          })
          template_data.counts[:errors] += 1
          template_data.testsuites[-1].counts[:errors] += 1
        end

        def report
          require 'mustache'
          with_io do |io|
            io << Mustache.render(TPL, template_data)
          end
        end

      private

        def with_io(&bl)
          case io = @path_or_io
          when IO, StringIO
            bl.call(io)
          else
            Path(io).open('w', &bl)
          end
        end

      end # class JunitXmlFile
    end # class Reporter
  end # class Tester
end # module Webspicy
