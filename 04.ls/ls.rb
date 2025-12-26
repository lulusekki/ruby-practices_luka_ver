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
    stats = files.map { |file| File.stat(file) }

    hard_link_width = stats.map { |stat| stat.nlink.to_s.length }.max
    file_size_width = stats.map { |stat| stat.size.to_s.length }.max
    last_modified_month_width = stats.map { |stat| stat.mtime.strftime('%-m月').length }.max

    puts "total #{total(files)}"

    files.each do |file|
      puts [
        permission(file),
        hard_link(file).to_s.rjust(hard_link_width),
        owner_name(file),
        group_name(file),
        file_size(file).to_s.rjust(file_size_width),
        last_modified_month(file).to_s.rjust(last_modified_month_width),
        last_modified_day(file),
        last_modified_hour_minute(file),
        file
      ].join(' ')
    end
  end

  private

  def total(files)
    files.sum { |file| File.stat(file).blocks }
  end

  def permission(file)
    [
      file_type(file),
      owner(file),
      group(file),
      other_group(file)
    ].join
  end

  def hard_link(file)
    File.stat(file).nlink
  end

  def owner_name(file)
    Etc.getpwuid(File.stat(file).uid).name
  end

  def group_name(file)
    Etc.getgrgid(File.stat(file).gid).name
  end

  def file_size(file)
    File.stat(file).size
  end

  def last_modified_month(file)
    File.mtime(file).strftime('%-m月')
  end

  def last_modified_day(file)
    File.mtime(file).strftime('%d')
  end

  def last_modified_hour_minute(file)
    File.mtime(file).strftime('%H:%M')
  end

  def file_mode(file)
    File.stat(file).mode.to_s(8)
  end

  def file_type(file)
    FILE_TYPE.fetch(file_mode(file)[0..1])
  end

  def owner(file)
    mode = file_mode(file)[-3]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
  end

  def group(file)
    mode = file_mode(file)[-2]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
  end

  def other_group(file)
    mode = file_mode(file)[-1]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
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
