class Acordformfield < ActiveRecord::Base
  belongs_to :acordform


  def xposoffset
    self.xpos + 29
  end

  def yposoffset
    self.ypos + 30
  end

  def heightoffset
    self.height - 4
  end

  def widthoffset
    self.width
  end

end
