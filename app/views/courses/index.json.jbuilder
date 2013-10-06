json.array!(@courses) do |course|
  json.extract! course, :title, :description, :user_id, :language, :prerequisites, :duration
  json.url course_url(course, format: :json)
end
