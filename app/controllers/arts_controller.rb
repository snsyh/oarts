class ArtsController < ApplicationController
  require 'time'
  require 'date'

  def index
    @condYear = params[:y] || "all"
    @condMonth = params[:m] || []
    @condDay = params[:d] || []
    @listMonth = []
    @listDay = []
    @arts = Art.event_year(@condYear).event_month(@condMonth).event_day(@condDay).order('id DESC').page(params[:page])

    @listMonth = Art.month_list(@condYear)

    @listDay = Art.day_list(@condYear, @condMonth)
    #@days.each do |art|
      #@listMonth[@listMonth.length] = art.event_date.strftime('%m') unless @listMonth.include?(art.event_date.strftime('%m'))
    #end
  end
end
