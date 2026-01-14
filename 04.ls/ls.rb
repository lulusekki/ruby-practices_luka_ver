#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

COLUMNS = 3
BLANK = 2

FILE_TYPE = {
  '01' => 'p',
  '02' => 'c',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's',
  '40' => 'd'
}.freeze

PERMISSION_MODE = {
  '000' => '---',
  '001' => '--x',
  '010' => '-w-',
  '011' => '-wx',
  '100' => 'r--',
  '101' => 'r-x',
  '110' => 'rw-',
  '111' => 'rwx'
}.freeze

def main
  files = Dir.glob('*')
  if ARGV.include?('-l')
    LongOption.new.output(files)
  else
    Default.new.output(files)
  end
end

class LongOption
  def output(files)

    rows = build_row(files)
    widths = calculate_widths(rows)

    puts "total #{rows.sum {| row | row[:blocks]}}"
    rows.each do |row|
      puts [
        row[:permission],
        row[:hard_link].to_s.rjust(widths[:hard_link]),
        row[:owner_name].ljust(widths[:owner_name]),
        row[:group_name].ljust(widths[:group_name]),
        row[:file_size].to_s.rjust(widths[:file_size]),
        row[:last_modified],
        row[:file]
      ].join(' ')
    end
  end

  private

  def calculate_widths(rows)
    {
      hard_link: rows.map { |row| row[:hard_link].to_s.length }.max,
      owner_name: rows.map { |row| row[:owner_name].length }.max,
      group_name: rows.map { |row| row[:group_name].length }.max,
      file_size: rows.map { |row| row[:file_size].to_s.length }.max
    }
  end

  def build_row(files)
    files.map do |file|
       stat = File.stat(file)
      {
        blocks: stat.blocks,
        permission: permission(stat),
        hard_link: stat.nlink,
        owner_name: Etc.getpwuid(stat.uid).name,
        group_name: Etc.getgrgid(stat.gid).name,
        file_size: stat.size,
        last_modified: last_modified(stat),
        file: file
      }
    end
  end

  def permission(stat)
    [
      file_type(stat),
      owner(stat),
      group(stat),
      other_group(stat)
    ].join
  end

  def file_type(stat)
    FILE_TYPE.fetch(stat.mode.to_s(8)[0..1])
  end

  def owner(stat)
    mode = stat.mode.to_s(8)[-3]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
  end

  def group(stat)
    mode = stat.mode.to_s(8)[-2]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
  end

  def other_group(stat)
    mode = stat.mode.to_s(8)[-1]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
  end

  def last_modified(stat)
    modified_time = stat.mtime
    modified_time.strftime("%_m月 %_d %H:%M")
  end
end

class Default
  def output(files)
    file_grid, column_width = build_grid(files)
    file_grid.each do |files|
      files.each do |file|
        print file.to_s.ljust(column_width + BLANK, ' ')
      end
      puts
    end
  end

  private

  def build_grid(files)
    remainder = files.size % COLUMNS
    padding_count = (COLUMNS - remainder) % COLUMNS
    padded_files = files + Array.new(padding_count, '')
    row_count = padded_files.size / COLUMNS
    file_grid = padded_files.each_slice(row_count).to_a.transpose
    column_width = files.map(&:length).max

    [file_grid, column_width]
  end
end

main
