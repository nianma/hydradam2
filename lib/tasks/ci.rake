desc "Run ci"
task :ci do

  require 'jettywrapper'

  # Set the version of hydra-jetty we want, and download a clean copy of it.
  Jettywrapper.hydra_jetty_version = 'v8.4.0'
  Jettywrapper.clean

  # Copy config from solr_conf/ and fedora_conf/ directories to Solr and Fedora downloaded from hydra-jetty repo.
  Rake::Task['jetty:config'].invoke
  
  # Get the jetty params needed to pass to Jettywrapper.wrap() below.
  jetty_params = Jettywrapper.load_config.merge({
    # The :startup_wait value is the number of seconds Jettywrapper will wait
    # while checking to see if jetty started. A high value helps ensure Travis
    # builds don't timeout.
    :startup_wait=> 180
  })
  
  puts "Starting Jetty..."

  # Jettywrapper.wrap() will ensure jetty is started and available before
  # running the code in the block passed to it.
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end

  raise "test failures: #{error}" if error
end