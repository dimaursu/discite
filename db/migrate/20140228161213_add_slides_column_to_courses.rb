class AddSlidesColumnToCourses < ActiveRecord::Migration
  def self.up
    add_attachment :courses, :slides
  end

  def self.down
    remove_attachment :courses, :slides
  end
end
