task :nhcmail => :environment do




  require 'nokogiri'
  doc = Nokogiri::XML(open("http://www.nhc.noaa.gov/index-at.xml"))

 flag = doc.xpath("//description").last
   if flag.to_str[0..19] == "No tropical cyclones"
      puts "NO"
   else
     Processalert.sendalert("mdesiato@gicunderwriters.com","mdesiato@bindlink.com",flag.to_str,doc.to_str).deliver
   end

end