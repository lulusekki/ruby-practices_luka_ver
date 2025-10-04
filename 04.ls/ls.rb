#!/usr/bin/env ruby
# frozen_string_literal: true

ORDER_COLUM = 3
PADDING = 2

def main
  files = Dir.glob("*")
  
  return 0 if files.empty?
  
  quotient_and_remainder = files.size.divmod(ORDER_COLUM)
  padding_count = (ORDER_COLUM - quotient_and_remainder[1]) % ORDER_COLUM
  paddings = [' '] * padding_count
  padded_files = (files << paddings).flatten
  rows_count = padded_files.size / ORDER_COLUM
  files_grid = padded_files.each_slice(rows_count).to_a
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