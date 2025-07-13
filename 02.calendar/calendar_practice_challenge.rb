#!/usr/bin/env ruby
require 'date'
require 'optparse'

# どのタイミングの日付(カレンダー)を表示するか決める
params = {} # paramsの初期値
opt = OptionParser.new

# ハッシュ化させる
params = ARGV.getopts("m:", "y:")

# これはおまじない
opt.parse!(ARGV) 

# 個々でも扱えるよに変数に格納
option_m = params["m"].to_i # paramsはハッシュなのでキーだけを出力。何を入力してもStringが返ってくる。一旦はintに変換して出力。その後に不正データが入力された場合のエラーハンドリングを行う
option_y = params["y"].to_i

# puts option_m # 変数に格納した-mの引数を利用する
# puts option_y # 変数に格納した-yの引数を利用する
# puts params # ARGVのハッシュを出力させる


# ここからは、ゴミデータを入力されたときに エラーになる
# オプションがmax2つ
# 今のコードだと、`./calendar_practice_challenge.rb -m 50 100 -y a`、`./calendar_practice_challenge.rb -m 50 100 -y a`、こんな感じで配列を2つ以上作れてしまう
# 2つ以上ならエラー、
# 両方とも整数でないなら、エラー
# -mの時のみ、整数なら実行

# オプションがあるか、ないか、
# 配列を加工する
# オプションでnilがあったら、nilを配列に加える


# =begin

# 日付に基本オブジェクトを作成
day = Date.new(option_y, option_m, 1)
year = day.year
mon = day.month

# 月初の最初の日を取得
start_day = Date.new(year, mon, 1)

# 月末最終日の取得
end_day = Date.new(year, mon, -1)

# 11. オプションを設定する

# .wdayで0(日曜日)〜6(月曜日)を取得
day_of_week_num = start_day.wday # -> Integer

# 日数 + 必要な要素数の配列を作る
month_days_array = ["　"] * day_of_week_num + (start_day..end_day).map{ |month_days| month_days.strftime("%d")} # --> => "全角の空白" + Array<String

# 配列内の値を7分割
week_divide = month_days_array.each_slice(7)

# 表示命令
puts "      #{mon}月 #{year}"
puts "日 月 火 水 木 金 土" # 日曜始まりならこれだけ？後で変数化するかも
week_divide.each do |c|
  puts c.join(" ")
end

# TODO：やること
# オプションの設定
# `-m`で月を、`-y`で年を指定できる
# ただし、`-y`のみ指定して一年分のカレンダーを表示する機能の実装は不要
# オプションの標準ライブラリの参考URL：https://docs.ruby-lang.org/ja/latest/library/optparse.html
# macのcalコマンドだと、当日は文字と背景色が反転している
# =end