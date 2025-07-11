# お題：3の倍数のときは数の代わりに｢Fizz｣と、5の倍数のときは｢Buzz｣とプリントし、3と5両方の倍数の場合には｢FizzBuzz｣と表示
# メモ：もし、3で割り切れたら(0)ならfizz、5で割り切れたら(0)ならbuzz、3と5両方の倍数(LCM15)ならfizzbuzz。それ以外なら配列内の数字を表示(puts)

(1..20).each do | num |
  if num % 15 == 0
    puts "FizzBuzz"
  elsif num % 5 == 0
    puts "Buzz"
  elsif num % 3 == 0
    puts "Fizz"
  else puts num
  end
end
