class ArtsColumn < ActiveRecord::Migration
  def change
    add_column :arts, :event_year, :string
    add_column :arts, :event_month, :string
  end
end
