task :morningmail => :environment do

  MorningtaskMailer.morningreminder("mdesiato@gmail.com").deliver



end