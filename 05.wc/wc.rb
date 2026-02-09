#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8
MIN_FILES_TOTAL = 2

def main
  options = parse_options

  if ARGV.empty?
    content = $stdin.read
    counts = calculate_counts(content)
    print_counts(options, counts, '')
  else
    totals = Hash.new(0)
    ARGV.each do |file_name|
      content = File.read(file_name)
      counts = calculate_counts(content)

      options.each { |option| totals[option] += counts[option] }

      print_counts(options, counts, file_name)
    end

    print_counts(options, totals, 'total') if ARGV.size >= MIN_FILES_TOTAL
  end
end

def parse_options
  options = []

  OptionParser.new do |opt|
    opt.on('-l') { options << :line }
    opt.on('-w') { options << :word }
    opt.on('-c') { options << :byte }

    opt.parse!(ARGV)
  end

  options.empty? ? %i[line word byte] : options
end

def calculate_counts(content)
  {
    line: content.count("\n"),
    word: content.scan(/\S+/).size,
    byte: content.bytesize
  }
end

def print_counts(options, counts, label)
  output_contents = options.map do |option|
    counts[option].to_s.rjust(WIDTH)
  end

  puts "#{output_contents.join(' ')} #{label}"
end

main
