class Movie < ActiveRecord::Base
 # @ratings = {a
  @ratings = ['G','PG', 'PG-13', 'R']
  def self.getRatings
    @ratings
  end
end
