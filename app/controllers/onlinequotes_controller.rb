class OnlinequotesController < ApplicationController
  layout 'onlinequoting'


  def index
    @qualifyingquestions = Qualifyingquestion.where('class_code = ?', 16900)
  end

  def new
    @onlinequote = Onlinequote.new
    @qualifyingquestions = Qualifyingquestion.where('class_code = ?', 16900)
  end

end
