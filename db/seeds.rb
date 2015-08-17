# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)





  admin = User.where(email: 'admin@codyssey.com').first_or_create
  admin.update_attributes(password: 'hetauda04',password_confirmation: 'hetauda04', name: 'Admin', superadmin: true)
  admin.roles << Role.where(name: 'admin').first_or_create
