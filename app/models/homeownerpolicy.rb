class Homeownerpolicy < ActiveRecord::Base
  belongs_to :policy
  belongs_to :hoconsttype
  belongs_to :hoform

  attr_accessible :dwelling_coverage, :contents_coverage, :liability_coverage,:medpay_coverage, :otherstructure_coverage, :lossofuse_coverage, :deductible, :hurricane_deductible, :construction_type, :year_built, :sq_footage, :number_rooms, :roof_age, :usage, :alarm, :swimming_pool, :fire_station, :replacement_cost
end
