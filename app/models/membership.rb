class Membership < ActiveRecord::Base
  # Join class of user and group
  belongs_to :user
  belongs_to :group
end

