task :removedocuments => :environment do






    deletedocs = Document.where("created_at < '11/19/2012'").find_all_by_generalagency_id(1)

    deletedocs.each do |dd|
      Delayed::Job.enqueue Deletedocument.new(dd.id)
    end








end