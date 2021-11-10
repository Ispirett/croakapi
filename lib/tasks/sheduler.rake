desc "Delete messages every 24 hours"

LOG = Logger.new('log/cron.log')
task :delete_messages => :environment do
  Message.where(created_at: 1.day.ago..).destroy_all
  LOG.info("Messages deleted")
end
