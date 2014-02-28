user = User.create!(email: 'user@example.com', password: 'password',
                    language: 'ro')
user.courses << Course.new(title: 'Short VIM introduction')
