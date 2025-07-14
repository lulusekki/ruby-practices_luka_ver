#!/usr/bin/env ruby
require 'date'
require 'optparse'

# 1️⃣ オプション周りの処理

# 基本オブジェクトの作成。オプションのデフォルト値を最初に作る
option_m = Date.today.month
option_y = Date.today.year

# オプションを取得。解析、ハッシュ化させる
params = ARGV.getopts("m:", "y:")

# デフォルトを使うか、オプションを使うかの処理
option_m = params["m"].to_i if params["m"]
option_y = params["y"].to_i if params["y"]

# 2️⃣ 日付関連の処理

# 月初の最初の日を取得
start_day = Date.new(option_y, option_m, 1)

# 月末最終日の取得
end_day = Date.new(option_y, option_m, -1)

# .wdayで0(日曜日)〜6(月曜日)を取得
day_of_week_num = start_day.wday

# 日数 + 必要な要素数の配列を作る
month_days_array = ["　"] * day_of_week_num + (start_day..end_day).map{ |month_days| month_days.strftime("%e")}

# 配列内の値を7分割
week_divide = month_days_array.each_slice(7)

# 3️⃣ 表示命令
puts "      #{option_m}月 #{option_y}"
puts "日 月 火 水 木 金 土"
week_divide.each do |c|
  puts c.join(" ")
end
