class CreateGatherings < ActiveRecord::Migration[5.1]
  def change
    create_table :gatherings do |t|
    	t.string :content
        t.string :title
        t.string :name
        t.integer :user_id

      t.timestamps
    end
  end
end
