class LookController < ApplicationController
  before_action :load

  def index
  end

  def available
    days = ['søn','man','tir','ons','tor','fre','lør']

    @button_types = { double: "btn-primary", hour: "btn-success", none: "btn-default disabled" }

    @dates = Date.today.upto(Date.today+5).map do |day|
      [ day.strftime("%Y%m%d"), days[day.wday], day==@date ]
    end
  end

  private

  def load

    @date = params[:date].nil? ? Date.today+1 : Date.parse(params[:date])

    Slot.load @date
  end

end
