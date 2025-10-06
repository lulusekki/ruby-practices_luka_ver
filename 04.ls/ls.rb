#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
BLANK = 2

def main
  files = Dir.glob('*')

  remainder = files.size % COLUMNS
  padding_count = (COLUMNS - remainder) % COLUMNS
  padded_files = files + Array.new(padding_count, '')
  rows_count = padded_files.size / COLUMNS
  files_grid = padded_files.each_slice(rows_count).to_a
  display_files = files_grid.transpose
  column_width = files.map(&:length).max
  output(display_files, column_width)
end

def output(display_files, column_width)
  display_files.each do |display_file|
    display_file.each do |file_name|
      print file_name.to_s.ljust(column_width + BLANK, ' ')
    end
    puts
  end
end

main
