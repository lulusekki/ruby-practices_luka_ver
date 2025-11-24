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
  default_files = Dir.glob('*')
  if ARGV.include?('-l')
    LongOption.new.output(default_files)
  else
    Default.new.output(default_files)
  end
end

class LongOption
  def output(default_files)
    files = default_files
    puts "total #{FileInformation.new.total(files)}"

    files.each do |file|
      puts [
        FileInformation.new.permission(file),
        FileInformation.new.hard_link(file).to_s.rjust(column_width(default_files)[:hard_link]),
        FileInformation.new.owner_name(file),
        FileInformation.new.group_name(file),
        FileInformation.new.file_size(file).to_s.rjust(column_width(default_files)[:file_size]),
        FileInformation.new.last_modified_month(file).to_s.rjust(column_width(default_files)[:last_modified_month]),
        FileInformation.new.last_modified_day(file),
        FileInformation.new.last_modified_hour_minute(file),
        FileInformation.new.file_name(file)
      ].join(' ')
    end
  end

  private

  def column_width(default_files)
    {
      hard_link: default_files.map { |file| File.stat(file).nlink.to_s.length }.max,
      file_size: default_files.map { |file| File.stat(file).size.to_s.length }.max,
      last_modified_month: default_files.map { |file| "#{File.mtime(file).month}月".to_s.length }.max
    }
  end
end

class FileInformation
  def total(default_files)
    total = default_files.map { |default_file| File.stat(default_file).blocks }
    total.flatten.sum
  end

  def permission(file)
    [
      file_type(file),
      owner(file),
      group(file),
      other_group(file)
    ].join('')
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
    "#{File.mtime(file).month}月"
  end

  def last_modified_day(file)
    File.mtime(file).strftime('%d')
  end

  def last_modified_hour_minute(file)
    File.mtime(file).strftime('%H:%M')
  end

  def file_name(file)
    file
  end

  private

  def file_mode(file)
    File.stat(file).mode.to_s(8)
  end

  def file_type(file)
    FILE_TYPE.fetch(file_mode(file)[0..1])
  end

  def owner(file)
    PERMISSION_MODE.fetch(file_mode(file)[-3].to_i.to_s(2).rjust(3, '0'))
  end

  def group(file)
    PERMISSION_MODE.fetch(file_mode(file)[-2].to_i.to_s(2).rjust(3, '0'))
  end

  def other_group(file)
    PERMISSION_MODE.fetch(file_mode(file)[-1].to_i.to_s(2).rjust(3, '0'))
  end
end

class Default
  def output(default_files)
    file_grid, column_width = build_grid(default_files)
    file_grid.each do |files|
      files.each do |file|
        print file.to_s.ljust(column_width + BLANK, ' ')
      end
      puts
    end
  end

  private

  def build_grid(default_files)
    remainder = default_files.size % COLUMNS
    padding_count = (COLUMNS - remainder) % COLUMNS
    padded_files = default_files + Array.new(padding_count, '')
    row_count = padded_files.size / COLUMNS
    file_grid = padded_files.each_slice(row_count).to_a.transpose
    column_width = default_files.map(&:length).max

    [file_grid, column_width]
  end
end

main
