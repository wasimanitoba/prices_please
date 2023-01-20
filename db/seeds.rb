# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Pipeline.create!(
  store: Store.create!(name: 'Superstore', location: 'St. James'),
  website: 'https://www.realcanadiansuperstore.ca/food/fruits-vegetables/c/28000',
  target: 'ul.product-tile-group__list li:nth-of-type(3n)',
  department: Department.create!(name: 'produce')
)