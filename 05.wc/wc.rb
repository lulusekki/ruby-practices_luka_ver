#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main
  keys = parse_options
  totals = Hash.new(0)

  if ARGV.empty?
    content = STDIN.read
    row_informations = file_information(content)
    print_counts(keys, row_informations, '')
  else
    ARGV.each do |file_name|
      content = File.read(file_name)
      row_informations = file_information(content)
  
      keys.each do |key|
        totals[key] += row_informations[key]
      end
  
      print_counts(keys, row_informations, file_name)
    end

    file_size = 2
    if ARGV.size >= file_size
      print_counts(keys, totals, 'total')
    end
  end
end


def parse_options
  keys = []

  OptionParser.new do |opt|
    opt.on('-l') {|key| keys << :line }
    opt.on('-w') {|key| keys << :word }
    opt.on('-c') {|key| keys << :byte }
  
    opt.parse!(ARGV)
  end
  
  keys.empty? ? [:line, :word, :byte] : keys
end

def file_information(content)
  {
    line: content.count("\n"),
    word: content.scan(/\S+/).size,
    byte: content.bytesize,
  }
end

def print_counts(keys, row_informations, label)
  values = keys.map do |key|
    row_informations[key].to_s.rjust(WIDTH)
  end

  puts "#{values.join(' ')} #{label}"
end

main
