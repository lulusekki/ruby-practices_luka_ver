path = "/Users/lukasekine/development"
files_in_directory = Array.new(Dir.entries(path)).sort

column_num = 3
remainder_num = files_in_directory.size.divmod(column_num)

add_array_num = (column_num - remainder_num[1]) % column_num

add_array_element = [" "] * add_array_num

new_files_in_directory = (files_in_directory << add_array_element).flatten

two_dimensional_array_num = new_files_in_directory.size / column_num

two_dimensional_array = new_files_in_directory.each_slice(two_dimensional_array_num).to_a

completed_array = two_dimensional_array.transpose

array_col_lengths = (files_in_directory.map { |item| item.length }).max

completed_array.each do |item|
  item.each do |row_itme|
    print row_itme.to_s.ljust(array_col_lengths + 2," ")
  end
  puts
end