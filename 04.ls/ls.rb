#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'
require 'matrix'
require 'debug'
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

PRMISSION_MODE = {
  '000' => '---',
  '001' => '--x',
  '010' => '-w-',
  '011' => '-wx',
  '100' => 'r--',
  '101' => 'r-x',
  '110' => 'rw-',
  '111' => 'rwx'
}.freeze

result = Benchmark.realtime do
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
      files = [
        permissions(default_files),
        hard_links(default_files),
        owner_names(default_files),
        group_names(default_files),
        file_sizes(default_files),
        last_modified_months(default_files),
        last_modified_days(default_files),
        last_modified_hour_minutes(default_files),
        file_names(default_files)
      ]

      files_count = files[0].size

      files_count.times do |index|
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
        sleep 0.1
      end
    end

    private

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

      permissions.transpose.map(&:join)
    end

    def file_types(default_files)
      file_modes(default_files).map do |file|
        hash_serch_number = file[0..1]
        FILE_TYPE.fetch(hash_serch_number)
      end
    end

    def owners(default_files)
      file_modes(default_files).map do |file|
        file_mode_number = file[-3]
        file_mode = file_mode_number.to_i.to_s(2).rjust(3, '0')
        PRMISSION_MODE.fetch(file_mode)
      end
    end

    def groups(default_files)
      file_modes(default_files).map do |file|
        file_group_number = file[-2]
        file_group = file_group_number.to_i.to_s(2).rjust(3, '0')
        PRMISSION_MODE.fetch(file_group)
      end
    end

    def other_groups(default_files)
      file_modes(default_files).map do |file|
        file_other_group_number = file[-1]
        file_other_group = file_other_group_number.to_i.to_s(2).rjust(3, '0')
        PRMISSION_MODE.fetch(file_other_group)
      end
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
      bird_elements = default_files.map do |file|
        last_modified_month_day = File.mtime(file).to_date
        six_month = Date.today << 6
        if last_modified_month_day > six_month
          File.mtime(file).strftime('%H:%M')
        else
          File.mtime(file).year
        end
      end
      build_grid(bird_elements)
    end

    def file_names(default_files)
      default_files
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
end
puts "変更後の処理時 #{result}s"
