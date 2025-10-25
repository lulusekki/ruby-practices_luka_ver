#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMNS = 3
BLANK = 2

def main
  files = ARGV.include?('-r') ? Dir.glob('*').reverse : Dir.glob('*')
  output(files)
end

def build_file_grid(files)
  remainder = files.size % COLUMNS
  padding_count = (COLUMNS - remainder) % COLUMNS
  padded_files = files + Array.new(padding_count, '')
  row_count = padded_files.size / COLUMNS
  file_grid = padded_files.each_slice(row_count).to_a.transpose
  column_width = files.map(&:length).max

  [file_grid, column_width]
end

def output(files)
  file_grid, column_width = build_file_grid(files)
  file_grid.each do |files|
    files.each do |file|
      print file.to_s.ljust(column_width + BLANK, ' ')
    end
    puts
  end
end

main
