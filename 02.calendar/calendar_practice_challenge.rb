#!/usr/bin/env ruby

require 'date'

# 基本オブジェクトを作成
day = Date.today
year = day.year
mon = day.month

# 月初の最初の日を取得
start_day = Date.new(year, mon, 1)

# 月末最終日の取得
end_day = Date.new(year, mon, -1)

# puts start_day
# puts end_day

# 1. yy-mm-dd形式での表示はこれ
=begin
(start_day..end_day).each{ |month_days| puts month_days.strftime("%Y-%m-%d") } # strftimeがstringを返す
=end

# 2. 日付の範囲取得(表示)のベースはこれよさそう
=begin
# (start_day..end_day).each{ |month_days| puts month_days.strftime("%d") }

# 3. puts(強制改行付き)で表示してるから、5個づつに分割する(カレンダーチックにする)
# each_sliceで分割が可能だが、データフォーマットと相性悪い
# これはだめ
=begin
a = (start_day..end_day).to_a # --> => Array
# a.strftime("%d")
b = a.join(",") # --> => String
puts b
=end

# 4. ざっくりだが、日付のデータフォーマントの変換と型変換はこれでいける
=begin
a = (start_day..end_day).each{ |month_days| puts month_days.strftime("%d") } # --> => Array
puts a.map{|a| a.strftime("%d") } # --> => String(mapで変換)
=end

# 5. データフォーマットを維持する(もうちょい綺麗にする)
# あと、上のだと2つの配列がputsされるので変換する
=begin
a = (start_day..end_day).map{ |month_days| month_days.strftime("%d")} # --> => range型をString(mapで変換)
puts a
=end

# 6. 7個づつに分割する(カレンダーチックにする)
# ダブルクォーテーションとカッコとカンマを除去する。putsで頑張った(多分明日コードを見たら理解できない)
=begin
a = (start_day..end_day).map{ |month_days| month_days.strftime("%d")} # --> => range型をString(mapで変換)。Array<String
b = a.each_slice(7) # --> => 新しい配列を7分割(Array<String)
# puts b.class # --> => Enumerator型？Array<Stringのまま？
=end

# 7. 配列型eachで配列を全て扱う。7分割は終わっているのでダブルクオーテーションを除去
=begin
a = (start_day..end_day).map{ |month_days| month_days.strftime("%d")} # --> => range型をString(mapで変換)。Array<String
b = a.each_slice(7) # --> => 新しい配列を7分割(Array<String)

b.each do |c|
  puts c.join(" ")
end
=end

# 8. ヘッダーの作成。年,月を表示。Macやcalコマンドと同じ見た目になっている
=begin
a = (start_day..end_day).map{ |month_days| month_days.strftime("%d")}
b = a.each_slice(7)

puts "      #{mon}月 #{year}"
b.each do |c|
  puts c.join(" ")
end
=end


# 9. ヘッダーの作成。曜日を漢字で表示。
=begin
day_of_week_num = (start_day..end_day).map{ |month_days| month_days.strftime("%d")}
week_divide = a.each_slice(7)

puts "      #{mon}月 #{year}"
puts "日 月 火 水 木 金 土" # 日曜始まりならこれだけ？後で変数化するかも
week_divide.each do |c|
  puts c.join(" ")
end
=end

# 10. 1日のスタートの位置を調整する
# 1日が何曜日かを取得して、概要の曜日から表示がスタートするようにする
# .wdayで0(日曜日)〜6(月曜日)を取得できる -> Integer

day_of_week_num = start_day.wday # -> Integer

month_days_array = ["　"] * day_of_week_num + (start_day..end_day).map{ |month_days| month_days.strftime("%d")} # --> => "全角の空白" + Array<String

week_divide = month_days_array.each_slice(7)

puts "      #{mon}月 #{year}"
puts "日 月 火 水 木 金 土" # 日曜始まりならこれだけ？後で変数化するかも
week_divide.each do |c|
  puts c.join(" ")
end

# TODO：やること
# オプションの設定
# -y 
# macのcalコマンドだと、当日は文字と背景色が反転している