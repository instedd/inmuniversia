require File.expand_path("../../extras/subscriber_and_child_importer", __FILE__)

namespace :importer do

  desc "Imports the subscribers from a CSV"
  task :subscribers => :environment do |task, args|
    begin
      file_name = File.join('csv', "datos.csv")
      count = SubscriberAndChildImporter.new.import! file_name
      puts "#{count} subscribers imported"
    rescue => exception
      puts "An error has occured when creating the subscribers!"
      puts exception
      puts exception.backtrace
    end
  end

end
