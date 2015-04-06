# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

e = Player.create name: "Even"
l = Player.create name: "Lasse"
p = Player.create name: "Petter"
s = Player.create name: "Simen"

g = Game.new
g.played_date = Date.today
g.spots << Spot.create(player: e, score: 11)
g.spots << Spot.create(player: l, score: 9)
g.save

g = Game.new
g.played_date = Date.today - 1
g.spots << Spot.create(player: e, score: 11)
g.spots << Spot.create(player: p, score: 8)
g.save

g = Game.new
g.played_date = Date.today - 2
g.spots << Spot.create(player: l, score: 11)
g.spots << Spot.create(player: p, score: 6)
g.save
