class Al3reader
  attr_accessor :alline, :header, :trgid, :bpiid, :lagid, :vehid, :agency_id

  def processgroup

    if self.header == '2TRG'
      algroup = Al3h2trg.new
      algroup.process(self.alline, self.agency_id)
    elsif self.header == '5PTS'
      algroup = Al3h5pts.new
      algroup.process(self.alline, self.trgid)
    elsif self.header == '5BIS'
      algroup = Al3h5bis.new
      algroup.process(self.alline, self.trgid)
    elsif self.header == '9BIS'
      algroup = Al3h9bis.new
      algroup.process(self.alline, self.trgid)
    elsif self.header == '5BPI'
      algroup = Al3h5bpi.new
      algroup.process(self.alline, self.trgid)
    elsif self.header == '5DRV'
      algroup = Al3h5drv.new
      algroup.process(self.alline, self.bpiid)
    elsif self.header == '5RMK'
      algroup = Al3h5rmk.new
      algroup.process(self.alline, self.bpiid)
    elsif self.header == '5LAG'
      algroup = Al3h5lag.new
      algroup.process(self.alline, self.bpiid)
    elsif self.header == '5VEH'
      algroup = Al3h5veh.new
      algroup.process(self.alline, self.lagid)
    elsif self.header == '6CVA'
      algroup = Al3h6cva.new
      algroup.process(self.alline, self.vehid, self.lagid)

    end
  end


end