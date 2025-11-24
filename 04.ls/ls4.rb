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

    files.each do |_file|
      puts [
        FileInformation.permission
      ].join(' ')
    end
  end
end

class FileInformation
  def total(default_files)
    total = default_files.map { |default_file| File.stat(default_file).blocks }
    total.flatten.sum
  end

  def permission(default_files)
    permissions = [
      file_type(default_files),
      owner(default_files),
      group(default_files),
      other_group(default_files)
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

  private

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
