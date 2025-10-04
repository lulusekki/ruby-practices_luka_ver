#!/usr/bin/env ruby
# frozen_string_literal: true

files_in_directory = Dir.glob("*")
order_column_num = 3

exit 0 if files_in_directory.empty?

remainder_num = files_in_directory.size.divmod(order_column_num)

add_array_num = (order_column_num - remainder_num[1]) % order_column_num

add_array_element = [' '] * add_array_num

new_files_in_directory = (files_in_directory << add_array_element).flatten

two_dimensional_array_num = new_files_in_directory.size / order_column_num

two_dimensional_array = new_files_in_directory.each_slice(two_dimensional_array_num).to_a

completed_array = two_dimensional_array.transpose

file_name_max = files_in_directory.map(&:length).max

def output(completed_array, file_name_max)
  add_padding_string = 2

  completed_array.each do |item|
    item.each do |row_itme|
      print row_itme.to_s.ljust(file_name_max + add_padding_string, ' ')
    end
    puts
  end
end

output(completed_array, file_name_max)
