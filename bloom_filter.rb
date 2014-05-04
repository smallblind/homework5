require 'murmurhash3'


words = String.new("")

bloom_filter = Array.new(10000, false) # Stores the hash values for the bloom filter all orginally set to false

filtered_file = String.new("") # File after it has been examined by the bloom filter

File.open('auto-words.txt', 'r') do |f1|  
  while line = f1.gets

    split_string = line.split(' ')

    split_string.each do |word|
      hash_value1 = ( MurmurHash3::V32.str_hash(word, 5) ) % 10000
      hash_value2 = ( MurmurHash3::V32.str_hash(word, 10) ) % 10000
      words = words + hash_value1.to_s + "  " + hash_value2.to_s + "\n"

      bloom_filter[hash_value1] = true
      bloom_filter[hash_value2] = true
    end

   
  end  
end
  
# Read the test paragraph to identify postive matches
File.open('test_paragraph.txt', 'r') do |f2|
   while line = f2.gets

      split_string = line.split(' ')

      # Hash each word and see if present in bloom filer
      split_string.each do |word|
        value1 = ( MurmurHash3::V32.str_hash(word, 5) ) % 10000
        value2 = ( MurmurHash3::V32.str_hash(word, 10) ) % 10000

        # If the word is present in the bloom filter, the filter it out of the file
        if bloom_filter[value1] == true && bloom_filter[value2] == true
          filtered_file = filtered_file + "**** "
          puts "A word was filtered\n"
        else
          filtered_file = filtered_file + word + " "
        end
      end

      filtered_file = filtered_file + "\n" # Add new line at end of each line

   end
end

# Print the filtered text to a file
File.open('filtered_text.txt', 'w') do |f3|
  f3.puts filtered_file
end 
