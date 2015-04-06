class Game < ActiveRecord::Base

  has_many :spots, dependent: :destroy, inverse_of: :game
  has_many :players, through: :spots

  accepts_nested_attributes_for :spots

  validates :spots, length: {minimum: 2, maximum: 2}
  #validates_associated :spots

  validate :must_have_a_winner

  def must_have_a_winner
    if self.spot1.score == self.spot2.score
      errors.add(:spots, "kan ikke ha samme antall poeng.")
    end

  end

  def winner
    self.spots.order("score DESC").first
  end

  def spot1
    self.spots[0]
  end

  def spot2
    self.spots[1]
  end

end
