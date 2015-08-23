class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :memberships
  has_many :groups, :through => :memberships

  has_many :bills

  #attr_accessible :password, :password_confirmation

  def self.all_except(user)
    where.not(id: user)
  end

end


