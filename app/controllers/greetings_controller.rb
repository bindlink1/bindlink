class GreetingsController < ApplicationController
before_filter :authenticate_user!

  def hello
	@message= "Hello, today you are on your way!"
  end
  def goodbye
	@message= "Not you."
  end

end
