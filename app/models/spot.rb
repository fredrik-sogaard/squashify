class Spot < ActiveRecord::Base

  belongs_to :player
  belongs_to :game

  validates :player, presence: true
  #validates :game, presence: true #fungerer ikke for nested_attrs fra game... ??
  validates :score, numericality: { only_integer: true }

  def winner?
    self==self.game.winner
  end

  def points
    self.winner? ? 1 : 0
  end

end
