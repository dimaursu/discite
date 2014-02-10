class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :language
      t.text :prerequisites
      t.datetime :starts_at

      t.timestamps
    end
  end
end
