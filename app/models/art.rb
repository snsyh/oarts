class Art < ActiveRecord::Base
  mount_uploader :art_image, ArtUploader
  paginates_per 12

  scope :event_year, ->(year) {
    if year =~ /[0-9]{4}/
       where("event_year = ?", year)
    elsif year != 'all'
       where("1 = 0")
    end
  }

  scope :event_month, ->(month) {
    months = month.split(",")
    if months.present?
       where(event_month: months)
    end
  }

  scope :event_day, ->(day) {
    days = day.split(",")
    if days.present?
       where(event_day: days)
    end
  }

  scope :month_list, ->(year) {
    if year =~ /[0-9]{4}/
       where("event_year = ?", year).group(:event_month).order(:event_month)
    else
       where("0 = 0").group(:event_month).order(:event_month)
    end
  }

  scope :day_list, ->(year, month) {
    months = month.split(",")

    if year =~ /[0-9]{4}/ && months.present?
       yearMonths = []
       months.each do |m|
           yearMonths.push(year + m)
       end
       where(event_year_month: yearMonths).group(:event_day).order(:event_day)
    elsif year == 'all' && months.present?
       where(event_month: months).group(:event_day).order(:event_day)
    else 
       where("0 = 0").group(:event_day).order(:event_day)
    end
}
end
