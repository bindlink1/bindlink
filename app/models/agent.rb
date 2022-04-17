class Agent < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:first_name, :last_name, :agency_name, :agency_id

  belongs_to :agency
  belongs_to :generalagency
  has_many :conversations
  has_many :submissionposts
  has_many :notes
  has_many :clients
  has_many :tasks
  has_many :statements

  #does exactly what is says...checks if the agent logged in is a general agent
  def isgeneralagent
    @response
    if self.generalagency_id == 0
      @response = "Retail"
    else
      @response = "GA"
    end
  end

  def getagencyid
    @response

    if self.isgeneralagent == "GA"
      @response = self.generalagency_id
    else
      @response = self.agency_id
    end


  end

  def fullname

    @fullname = self.first_name + " " + self.last_name

  end

  def opentaskcount
    count = Task.new.opentaskcount(self.id)
  end

  def overduetaskcount
    count = Task.new.overduetaskcount(self.id)
  end

end
