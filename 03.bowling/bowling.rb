#!/usr/bin/env ruby

# 前提処理
X = "X"
scores = ARGV[0].split(",")
frames = []
process_frames = []

# 引数の前処理：引数(投球データ)をフレームに当てはめる。10フレームもしっかり処理する
# そのためには、格納するインデックス番号が0〜8なら、今の処理通りに追加する、9以上がある場合は全て1つのフレームとして処理する
scores.each do |score|
  if frames.size < 9
    # 1〜9フレームの処理
    if score == X
      frames << [10]
    else
      process_frames << score.to_i
      if process_frames.size == 2
        frames << process_frames
        process_frames = []
      end
    end
  else
    # 10フレーム目：残りのすべてをまとめて
    process_frames << if score == X
      10
    else
      score.to_i
    end
  end
end

frames << process_frames unless process_frames.empty?

p frames
