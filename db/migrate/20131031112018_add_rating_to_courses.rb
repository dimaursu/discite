class AddRatingToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :rating, :integer
  end
end
