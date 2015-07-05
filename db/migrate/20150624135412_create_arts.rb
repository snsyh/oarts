class CreateArts < ActiveRecord::Migration
  def change
    create_table :arts do |t|
      t.string :userid
      t.string :username
      t.date :event_date
      t.string :art_image

      t.timestamps null: false
    end
  end
end
