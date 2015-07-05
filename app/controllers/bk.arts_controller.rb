class ArtsController < ApplicationController
  require 'time'
  require 'date'

  def index
    @condYear = params[:y] || "all"
    @condMonth = params[:m] || []
    @condUserid = params[:id] || []
    @listUserid = []
    @listMonth = []
    @arts = Art.event_year_month(@condYear, @condMonth).userid(@condUserid).order('id DESC').page(params[:page])

    @defaults = Art.event_year(@condYear)
    @defaults.each do |art|
      @listMonth[@listMonth.length] = art.event_date.strftime('%m') unless @listMonth.include?(art.event_date.strftime('%m'))
      #@listUserid[@listUserid.length] = art.userid unless @listUserid.include?(art.userid)
    end
    
    #@listUserid = @listUserid.sort
    @listMonth = @listMonth.sort
  end
end
