require_relative 'shared_config'

webspicy_config(Path.dir) do |c|
  c.world.documentation_output = StringIO.new
  c.world.progress_output = StringIO.new
  c.world.summary_output = StringIO.new
  c.colorize = false
  c.reporter = Webspicy::Tester::Reporter::Composite.new
  c.reporter << Tester::Reporter::Documentation.new(c.world.documentation_output)
  c.reporter << Tester::Reporter::Progress.new(c.world.progress_output)
  c.reporter << Tester::Reporter::Summary.new(c.world.summary_output)
  c.reporter << Tester::Reporter::ErrorCount.new
end
