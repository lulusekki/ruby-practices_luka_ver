#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
frames = []
pending_frames = []

scores.each do |score|
  if frames.size < 9
    if score == 'X'
      frames << [10]
    else
      pending_frames << score.to_i
      if pending_frames.size == 2
        frames << pending_frames
        pending_frames = []
      end
    end
  else
    pending_frames << if score == 'X'
                        10
                      else
                        score.to_i
                      end
  end
end

frames << pending_frames unless pending_frames.empty?

total_scores = []

frames.each_with_index do |frame, idx|
  if frame.sum < 10 && frame.length == 2
    total_scores << frame.sum
  elsif frame.sum == 10 && frame.length == 2
    spare_bonus = if frames[idx + 1]
                    frames[idx + 1][0]
                  else
                    0
                  end
    total_scores << frame.sum + spare_bonus
  else
    frame.sum == 10 && frame.length == 1
    strike_bonus = frames[idx + 1..idx + 2].flatten.first(2).sum
    total_scores << frame.sum + strike_bonus
  end
end

p total_scores.sum
