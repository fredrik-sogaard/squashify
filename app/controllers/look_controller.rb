class LookController < ApplicationController

  def index

    @date = params[:id].nil? ? Date.today+1 : Date.today + params[:id].to_i

    days = ['søn','man','tir','ons','tor','fre','lør']
    @dates = (0..2).map do |id|
      day = Date.today + id

      [ id , days[day.wday], day==@date ]
    end

    Slot.load @date

  end

end
