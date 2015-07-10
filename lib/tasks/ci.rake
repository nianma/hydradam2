desc "Run CI tests"
task :ci do
  # Any special setup for Travis CI can go in here.
  Rake::Task['spec'].invoke
end