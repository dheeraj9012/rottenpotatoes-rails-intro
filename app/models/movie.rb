class Movie < ActiveRecord::Base
  def self.rat
   Movie.pluck(:rating)
  end
end
