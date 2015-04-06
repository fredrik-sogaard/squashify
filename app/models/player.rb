class Player < ActiveRecord::Base

  has_many :spots
  has_many :games, through: :spots

  def win_percentage
    percent = self.spots.map(&:points).reduce(0, &:+) * 100 / self.spots.count.to_f
    return percent.nan? ? nil : percent
  end

  def points
    self.spots.map(&:points).sum
  end

end
