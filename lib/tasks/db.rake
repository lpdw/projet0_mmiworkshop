# http://manuel.manuelles.nl/blog/2012/01/19/rake-pull-me-that-db/
# http://adam.herokuapp.com/past/2009/2/11/taps_for_easy_database_transfers/

namespace :db do
  desc "Pull a postgres database from Heroku"

  task pull: :environment do
    configuration = Rails.application.config.database_configuration["development"]

    Bundler.with_clean_env do
      sh "heroku pg:backups capture"
      sh "curl -o latest.dump `heroku pg:backups public-url`"
      sh "rake db:drop"
      sh "rake db:create"

      begin
        sh "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d #{configuration['database']} latest.dump"
      rescue
        "There was warnings/errors while restoring"
      ensure
        sh "rm latest.dump"
      end
    end
  end
end
