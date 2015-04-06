class GamesController < ApplicationController

  def index
    @game = Game.new
    @game.spots.build player: Player.first
    @game.spots.build player: Player.last
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      flash[:success] = "Kampen er registrert."
      redirect_to games_url
    else
      render :index
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.required(:game).permit!
    end

end
