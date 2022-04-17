class Acordform < ActiveRecord::Base

  has_many :acordformfields

  def to_param
    form_name
  end

end
