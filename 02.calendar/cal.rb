#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts("m:", "y:")

month = params["m"] ? params["m"].to_i : Date.today.month
year = params["y"] ? params["y"].to_i : Date.today.year

start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)

head_space = Array.new(start_date.wday, "  ")
dates = (start_date..end_date).map { |date| date.day.to_s.rjust(2) }
month_dates = head_space + dates

week_rows = month_dates.each_slice(7)

puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"
week_rows.each do |week_dates|
  puts week_dates.join(" ")
end
