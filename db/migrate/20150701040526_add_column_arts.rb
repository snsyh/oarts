class AddColumnArts < ActiveRecord::Migration
  def change
    add_column :arts, :event_day, :string
  end
end
