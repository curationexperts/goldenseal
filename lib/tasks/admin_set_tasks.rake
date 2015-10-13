namespace :admin_set do

  desc 'List all the Admin Sets'
  task :list => :environment do
    if AdminSet.count == 0
      puts "There are currently no AdminSets"
    else
      puts "ID : Title"
      puts "--------------------"
      AdminSet.all.each do |set|
        puts "#{set.id} : \"#{set.title}\""
      end
    end
  end

end
