namespace :test do
  require "rspec/core/rake_task"

  tests = []

  desc "Runs unit tests on the library itself"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/test_*.rb"
    t.rspec_opts = ["-Ilib", "-Ispec/unit", "--color", "--backtrace", "--format=progress"]
  end
  tests << :unit

  require 'path'
  Path.dir.parent.glob("examples/*").select{|f| f.directory? }.each do |file|
    test_name = file.basename.to_s.to_sym
    desc "Runs the integration tests on the #{file.basename} example"
    task(test_name) do
      system("cd #{file} && rake")
    end
    tests << test_name
  end

  task :all => tests
end

desc "Runs all tests, unit then integration on examples"
task :test => :'test:all'
