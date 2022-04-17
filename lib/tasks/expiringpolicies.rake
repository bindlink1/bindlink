task :expirepolicies => :environment do
  #creates a task to follow up with the policy before expiration
  Policy.new.expirepoliciestask
  #expires policies that have not renewed or cancelled
  Policy.new.expirepolicies
  Processalert.sendalert("mdesiato@bindlink.com","mdesiato@bindlink.com","expire done","allset").deliver


end