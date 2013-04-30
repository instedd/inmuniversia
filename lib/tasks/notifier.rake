namespace :notifier do
  
  desc "Starts notifier daemon continuously to run every day at 4PM"
  task :start => :environment do
    Notifier.start!
  end
  
end