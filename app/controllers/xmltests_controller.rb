class XmltestsController < ApplicationController

  def testpage

 @doc = Nokogiri::XML(File.open("bindlinkapp1.xml"))

  end

end