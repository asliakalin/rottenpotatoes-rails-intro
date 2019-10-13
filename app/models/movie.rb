class Movie < ActiveRecord::Base

	def self.get_ratings
		return Movie.select("DISTINCT rating").map(&:rating).sort
	end


end
