class Printing < ActiveRecord::Base
  belongs_to :card
  belongs_to :expansion

end
