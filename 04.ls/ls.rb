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
    @stats = files.map { |file| [file, File.stat(file)] }

    rows = build_row
    widths = calculate_widths

    puts "total #{total}"
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

  def calculate_widths
    {
      hard_link: @stats.map { |_, stat| stat.nlink.to_s.length }.max,
      owner_name: @stats.map { |_, stat| Etc.getpwuid(stat.uid).name.length }.max,
      group_name: @stats.map { |_, stat| Etc.getgrgid(stat.gid).name.length }.max,
      file_size: @stats.map { |_, stat| stat.size.to_s.length }.max
    }
  end

  def build_row
    rows = []
    @stats.each do |file, stat|
      rows << {
        permission: permission(stat),
        hard_link: hard_link(stat),
        owner_name: owner_name(stat),
        group_name: group_name(stat),
        file_size: file_size(stat),
        last_modified: last_modified(stat, '%b %e %H:%M'),
        file: file
      }
    end
    rows
  end

  def total
    @stats.sum { |stat| stat[1].blocks }
  end

  def permission(stat)
    [
      file_type(stat),
      owner(stat),
      group(stat),
      other_group(stat)
    ].join
  end

  def hard_link(stat)
    stat.nlink
  end

  def owner_name(stat)
    Etc.getpwuid(stat.uid).name
  end

  def group_name(stat)
    Etc.getgrgid(stat.gid).name
  end

  def file_size(stat)
    stat.size
  end

  def last_modified(stat, format)
    stat.mtime.strftime(format)
  end

  def file_mode(stat)
    stat.mode.to_s(8)
  end

  def file_type(stat)
    FILE_TYPE.fetch(file_mode(stat)[0..1])
  end

  def owner(stat)
    mode = file_mode(stat)[-3]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
  end

  def group(stat)
    mode = file_mode(stat)[-2]
    zero_padding_mode = mode.to_i.to_s(2).rjust(3, '0')
    PERMISSION_MODE.fetch(zero_padding_mode)
  end

  def other_group(stat)
    mode = file_mode(stat)[-1]
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
