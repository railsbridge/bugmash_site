namespace :bugmash do
  namespace :seed do
    desc 'seed some Participants'
    task :participants => :environment do
      how_many = ENV['count'] || ENV['COUNT'] || 25
      how_many.to_i.times do
        Participant.create!(:name => Forgery(:name).full_name,
                            :lighthouse_id => Forgery(:internet).user_name,
                            :github_id => Forgery(:internet).user_name,
                            :score => Forgery(:basic).number(:at_least => 25,
                                                             :at_most => 5000))
      end
    end

    namespace :production do
      desc 'seed the feeds'
      task :feeds => :environment do
        unless Feed.exists?
          feeds = { 'Lighthouse' => 'http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/events.atom', 'GitHub' => 'http://github.com/feeds/rails/commits/rails/master' }

          feeds.each { |name, url| Feed.create!(:name => name, :url => url) }
        end
      end

      desc 'seed the jobs'
      task :jobs => [:environment, 'jobs:clear'] do
        Feed.all.each { |feed| Delayed::Job.enqueue FeedJob.new(feed.id) }
      end

      desc 'seed the first contribution'
      task :contribution => :environment do
        Contribution.create!(:lighthouse_id => 4582, :point_value => 0) unless Contribution.exists?
      end

      desc 'seed test event'
      task :event => :environment do
        Event.create!(:name => 'Testing Bugmash Scoreboard', :current => true)
      end
    end
  end

  desc 'seed the development database'
  task :seed => 'bugmash:seed:participants'

  desc 'seed the production database'
  task :seed_production => ['bugmash:seed:production:contribution',
                            'bugmash:seed:production:feeds',
                            'bugmash:seed:production:jobs',
                            'bugmash:seed:production:event']
end
