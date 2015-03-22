class LookController < ApplicationController
  before_action :load

  def index
  end

  def available
    days = ['søn','man','tir','ons','tor','fre','lør']

    @dates = Date.today.upto(Date.today+5).map do |day|
      [ days[day.wday] + (day==Date.today+1 ? " (i morgen)" : "") , day.strftime("%Y%m%d") ]
    end
  end

  private

  def load
    @date = params[:date].nil? ? (Date.today+1).strftime("%Y%m%d") : params[:date]

    Slot.load @date
  end

end
