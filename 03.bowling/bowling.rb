#!/usr/bin/env ruby
# frozen_string_literal: true

X = 'X'
scores = ARGV[0].split(',')
frames = []
process_frames = []

scores.each do |score|
  if frames.size < 9
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
    process_frames << if score == X
      10
    else
      score.to_i
    end
  end
end

frames << process_frames unless process_frames.empty?

p frames
end

p total_scores.sum
