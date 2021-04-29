namespace :test do
  require "rspec/core/rake_task"

  tests = []

  desc "Runs unit tests on the library itself"
  RSpec::Core::RakeTask.new(:unit) do |t|
    require 'path'
    root_folder = Path.dir.parent
    test_results = root_folder/"test-results"
    puts (test_results/"unit-tests.xml").inspect
    t.pattern = "spec/unit/**/test_*.rb"
    t.rspec_opts = ["-Ilib", "-Ispec/unit", "--color", "--backtrace", "--format=progress", "--format RspecJunitFormatter", "--out #{test_results}/unit-tests.xml"]
  end
  tests << :unit

  require 'path'
  Path.dir.parent.glob("examples/*").select{|f|
    f.directory? && (f/"Rakefile").exists?
  }.each do |file|
    test_name = file.basename.to_s.to_sym
    desc "Runs the integration tests on the #{file.basename} example"
    task(test_name) do
      Bundler.with_original_env do
        x = system("cd #{file} && bundle exec rake")
        abort("Example test suite failed: #{file}") unless x
      end
    end
    tests << test_name
  end

  task :all => tests
end

desc "Runs all tests, unit then integration on examples"
task :test => :'test:all'
