class Player < ActiveRecord::Base

  has_many :spots
  has_many :games, through: :spots

  def win_percentage
    self.spots.map(&:points).reduce(0, &:+) / self.spots.count.to_f
  end

  def points
    self.spots.map(&:points).sum
  end

end
