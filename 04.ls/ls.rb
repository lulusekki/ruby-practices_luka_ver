#!/usr/bin/env ruby
# frozen_string_literal: true

ORDER_COLUMN = 3
BLANK = 2

def main
  files = Dir.glob('*')

  remainder = files.size % ORDER_COLUMN
  padding_count = (ORDER_COLUMN - remainder) % ORDER_COLUMN
  paddings = [''] * padding_count
  padded_files = files + paddings
  rows_count = padded_files.size / ORDER_COLUMN
  files_grid = padded_files.each_slice(rows_count).to_a
  display_files = files_grid.transpose
  column_width = files.map(&:length).max
  output(display_files, column_width)
end

def output(display_files, column_width)
  display_files.each do |display_file|
    display_file.each do |file_name|
      print file_name.to_s.ljust(column_width + PADDING, ' ')
    end
    puts
  end
end

main
