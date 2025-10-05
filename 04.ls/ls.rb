#!/usr/bin/env ruby
# frozen_string_literal: true

ORDER_COLUMN = 3
PADDING = 2

def main
  files = Dir.glob('*')

  remainder = files.size % ORDER_COLUMN
  blank_count = (ORDER_COLUMN - remainder) % ORDER_COLUMN
  blanks = [''] * blank_count
  blanked_files = (files << blanks).flatten
  rows_count = blanked_files.size / ORDER_COLUMN
  files_grid = blanked_files.each_slice(rows_count).to_a
  transposed_files = files_grid.transpose
  max_filename_length = files.map(&:length).max
  output(transposed_files, max_filename_length)
end

def output(transposed_files, max_filename_length)
  transposed_files.each do |item|
    item.each do |row_itme|
      print row_itme.to_s.ljust(max_filename_length + PADDING, ' ')
    end
    puts
  end
end

main
