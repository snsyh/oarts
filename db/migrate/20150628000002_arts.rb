class Arts < ActiveRecord::Migration
  def change
    add_column :arts, :event_year_month, :string
  end
end
