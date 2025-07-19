#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts("m:", "y:")

month = params["m"] ? params["m"].to_i : Date.today.month
year = params["y"] ? params["y"].to_i : Date.today.year

start_day = Date.new(year, month, 1)
end_day = Date.new(year, month, -1)

head_space = Array.new(start_day.wday, "　")
days = (start_day..end_day).map { |date| date.strftime("%e") }
month_days = head_space + days

week_rows = month_days.each_slice(7)

puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"
week_rows.each do |week_days|
  puts week_days.join(" ")
end
