# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)





  admin = User.find_or_create_by(email: 'admin@codyssey.com')
  admin.update_attributes(password: 'hetauda04',password_confirmation: 'hetauda04', superadmin: true)