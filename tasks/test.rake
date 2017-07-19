namespace :test do
  require "rspec/core/rake_task"

  desc "Run unit tests on the library itself"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/test_*.rb"
    t.rspec_opts = ["-Ilib", "-Ispec/unit", "--color", "--backtrace", "--format=progress"]
  end

  task :all => [ :unit ]
end
task :test => :'test:all'
