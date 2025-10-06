#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
BLANK = 2

def main
  files = Dir.glob('*')

  remainder = files.size % COLUMNS
  padding_count = (COLUMNS - remainder) % COLUMNS
  padded_files = files + Array.new(padding_count, '')
  row_count = padded_files.size / COLUMNS
  file_grid = padded_files.each_slice(row_count).to_a.transpose
  column_width = files.map(&:length).max
  output(file_grid, column_width)
end

def output(file_grid, column_width)
  file_grid.each do |display_file|
    display_file.each do |file_name|
      print file_name.to_s.ljust(column_width + BLANK, ' ')
    end
    puts
  end
end

main
