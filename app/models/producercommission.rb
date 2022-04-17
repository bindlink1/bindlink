class Producercommission < ActiveRecord::Base
  before_save :createbookmonthyear
  belongs_to :policypremiumtransaction


  def createbookmonthyear

    @createdon = Date.today


    self.book_month = @createdon.month
    self.book_year = @createdon.year




  end


end
