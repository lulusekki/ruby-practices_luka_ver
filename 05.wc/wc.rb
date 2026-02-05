#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main
  options = parse_options
  totals = Hash.new(0)

  if ARGV.empty?
    content = $stdin.read
    row_informations = file_information(content)
    print_counts(options, row_informations, '')
  else
    ARGV.each do |file_name|
      content = File.read(file_name)
      row_informations = file_information(content)

      options.each do |option|
        totals[option] += row_informations[option]
      end

      print_counts(options, row_informations, file_name)
    end

    file_size = 2
    print_counts(options, totals, 'total') if ARGV.size >= file_size
  end
end

def parse_options
  options = []

  OptionParser.new do |opt|
    opt.on('-l') { |_option| options << :line }
    opt.on('-w') { |_option| options << :word }
    opt.on('-c') { |_option| options << :byte }

    opt.parse!(ARGV)
  end

  options.empty? ? %i[line word byte] : options
end

def file_information(content)
  {
    line: content.count("\n"),
    word: content.scan(/\S+/).size,
    byte: content.bytesize
  }
end

def print_counts(options, row_informations, label)
  output_content = options.map do |option|
    row_informations[option].to_s.rjust(WIDTH)
  end

  puts "#{output_content.join(' ')} #{label}"
end

main
