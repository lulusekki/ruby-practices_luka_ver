#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'
require 'benchmark'

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
    long_option = LongOption.new
    long_option.output(default_files)
  else
    Default.new.output(default_files)
  end
end

class LongOption
  def output(default_files)
    files = output_grid(default_files)

    puts "total #{total(default_files)}"

    files[0].size.times do |index|
      output = [
        files[0][index],
        files[1][index],
        files[2][index],
        files[3][index],
        files[4][index],
        files[5][index],
        files[6][index],
        files[7][index],
        files[8][index]
      ]
      puts output.join(' ')
    end
  end

  private

  def output_grid(default_files)
    [
      permissions(default_files),
      hard_links(default_files),
      owner_names(default_files),
      group_names(default_files),
      file_sizes(default_files),
      last_modified_months(default_files),
      last_modified_days(default_files),
      last_modified_hour_minutes(default_files),
      default_files
    ]
  end

  def build_grid(bird_elements)
    column_width = bird_elements.map { |element| element.to_s.length }.max
    bird_elements.map { |element| element.to_s.rjust(column_width, ' ') }
  end

  def file_modes(default_files)
    default_files.map { |file| File.stat(file).mode.to_s(8) }
  end

  def total(default_files)
    total = default_files.map { |default_file| File.stat(default_file).blocks }
    total.flatten.sum
  end

  def permissions(default_files)
    permissions = [
      file_types(default_files),
      owners(default_files),
      groups(default_files),
      other_groups(default_files)
    ]

    Array.new(default_files.size) do |index|
      output = [
        permissions[0][index],
        permissions[1][index],
        permissions[2][index],
        permissions[3][index]
      ]
      output.join('')
    end
  end

  def file_types(default_files)
    file_modes(default_files).map { |file| FILE_TYPE.fetch(file[0..1]) }
  end

  def owners(default_files)
    file_modes(default_files).map { |file| PERMISSION_MODE.fetch(file[-3].to_i.to_s(2).rjust(3, '0')) }
  end

  def groups(default_files)
    file_modes(default_files).map { |file| PERMISSION_MODE.fetch(file[-2].to_i.to_s(2).rjust(3, '0')) }
  end

  def other_groups(default_files)
    file_modes(default_files).map { |file| PERMISSION_MODE.fetch(file[-1].to_i.to_s(2).rjust(3, '0')) }
  end

  def hard_links(default_files)
    build_grid(default_files.map { |file| File.stat(file).nlink })
  end

  def owner_names(default_files)
    build_grid(default_files.map { |file| Etc.getpwuid(File.stat(file).uid).name })
  end

  def group_names(default_files)
    build_grid(default_files.map { |file| Etc.getgrgid(File.stat(file).gid).name })
  end

  def file_sizes(default_files)
    build_grid(default_files.map { |file| File.stat(file).size })
  end

  def last_modified_months(default_files)
    build_grid(default_files.map { |file| "#{File.mtime(file).month}月" })
  end

  def last_modified_days(default_files)
    build_grid(default_files.map { |file| File.mtime(file).day })
  end

  def last_modified_hour_minutes(default_files)
    build_grid(default_files.map { |file| File.mtime(file).strftime('%H:%M') })
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
