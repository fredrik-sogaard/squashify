class BookingsController < ApplicationController

  def index

    @date = params[:id].nil? ? Date.today+1 : Date.today + params[:id].to_i

    days = t(:"date.abbr_day_names")
    @dates = (0..4).map do |id|
      day = Date.today + id

      [ id , days[day.wday], day==@date ]
    end

    utkanten = ["Lysaker","Bærum"]

    if params[:sted] == 'utkanten'
      @clubs = Club.all.select{|c| utkanten.include? c.name}
    else
      @clubs = Club.all.select{|c| not utkanten.include? c.name}
    end
    Slot.load @clubs, @date

  end

end
