#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
BLANK = 2

def main
  files = ARGV.include?('-a') ? Dir.entries('.').sort : Dir.glob('*')
  file_grid, column_width = build_file_grid(files, COLUMNS)
  output(file_grid, column_width)
end

def build_file_grid(files, columns)
  remainder = files.size % columns
  padding_count = (columns - remainder) % columns
  padded_files = files + Array.new(padding_count, '')
  row_count = padded_files.size / columns
  file_grid = padded_files.each_slice(row_count).to_a.transpose
  column_width = files.map(&:length).max

  [file_grid, column_width]
end

def output(file_grid, column_width)
  file_grid.each do |files|
    files.each do |file|
      print file.to_s.ljust(column_width + BLANK, ' ')
    end
    puts
  end
end

main
