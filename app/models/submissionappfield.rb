class Submissionappfield
  include ActiveModel::Serialization
  attr_accessor :display_name, :field_type, :required, :field_name, :field_options

  def initialize()
    @display_name = display_name
    @field_type = field_type
    @required = required
    @field_name = field_name
    @optionarray = Array.new
    @field_options = @optionarray

  end

end