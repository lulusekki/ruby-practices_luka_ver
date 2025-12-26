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

    hard_link_width = @stats.map { |_file, stat| stat.nlink.to_s.length }.max

    file_size_width = @stats.map { |_file, stat| stat.size.to_s.length }.max
    last_modified_month_width = @stats.map { |_file, stat| stat.mtime.strftime('%-m月').length }.max

    puts "total #{total}"

    # 設計修正メモ①：横にループさせながら、各行のデータを収集
    # この段段階では.rjustとかしない

    @stats.map do |file, stat|
      [
        permission(stat),
        hard_link(stat).to_s.rjust(hard_link_width),
        owner_name(stat),
        group_name(stat),
        file_size(stat).to_s.rjust(file_size_width),
        last_modified_month(stat).to_s.rjust(last_modified_month_width),
        last_modified_day(stat),
        last_modified_hour_minute(stat),
        file
      ].join(' ')
    end

    # 設計修正メモ②：列の幅を求める必要があれば、その列だけ最大の幅を求める

    # hogeから最大の幅を取得

    # hard_link_width = stats.map { |stat| stat.nlink.to_s.length }.max

    # file_size_width = stats.map { |stat| file_size.to_s.length }.max

    # last_modified_month_width = stats.map { |stat| stat.mtime.strftime('%-m月').length }.max

    # totalを計算して出力
    puts total

    # 設計修正メモ③：集めたデータをきれいに整形して出力する
    # hogeをきれいに整形して出力する
    # hoge.each do
    #   puts ...
    # end
  end

  private

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

  def last_modified_month(stat)
    stat.mtime.strftime('%-m月')
  end

  def last_modified_day(stat)
    stat.mtime.strftime('%d')
  end

  def last_modified_hour_minute(stat)
    stat.mtime.strftime('%H:%M')
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
