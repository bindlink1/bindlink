class Acordapplication
    def details

        @doc = Nokogiri::XML(File.open("customapps/125pg1.xml"))




          @doc.xpath("//field").each do |node|
                        puts  node.xpath('itemlocation/ae/ae').text
                        puts " "

                    node.xpath('itemlocation/ae').each do |nodetwo|
                         nodetwo.xpath('ae').each do |nodethree|
                           puts nodethree.text
                         end
                    end

        end

    end

end