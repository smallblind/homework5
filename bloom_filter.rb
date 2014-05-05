require 'murmurhash3' # Murmur hash gem

bloom_filter = Array.new(10000, false) # Stores the boolean values for the filter.

filtered_file = String.new("") # File after it has been examined and the matches repalced

input_file = ARGV[0] # Read the input file name from the first command line argument

# Read "illegal" auto word from the given text file, and hash into the bloom filter
File.open('auto-words.txt', 'r') do |f1|  
  while line = f1.gets

    split_string = line.split(' ')

    split_string.each do |word|

      # Hash the word twice using different seed values.
      hash_value1 = ( MurmurHash3::V32.str_hash(word, 5) ) % 10000
      hash_value2 = ( MurmurHash3::V32.str_hash(word, 10) ) % 10000

      bloom_filter[hash_value1] = true
      bloom_filter[hash_value2] = true
    end
  end  
end
  
# Read the given input file to identify and replace postive matches for illegal words.
File.open(input_file, 'r') do |f2|
   while line = f2.gets

      split_string = line.split(' ')

      # Hash each word and see if present in bloom filer
      split_string.each do |word|

        # Use temp word so the original word is maintained if there isn't a match
        temp_word = word
       
        # Remove extra characters from the word that will effect the results.
        word = word.tr(')(!.""$&,;:-','')

        # Convert the word to lowercase to match the input file
        word.downcase!

        value1 = ( MurmurHash3::V32.str_hash(word, 5) ) % 10000
        value2 = ( MurmurHash3::V32.str_hash(word, 10) ) % 10000


        # If the word is present in the bloom filter, the filter it out of the file
        if bloom_filter[value1] == true && bloom_filter[value2] == true
          filtered_file = filtered_file + "**** "
        else
          filtered_file = filtered_file + temp_word + " "
        end
      end

      filtered_file = filtered_file + "\n" # Add new line at end of each line

   end
end

# Print the filtered text to a file
File.open('filtered_text.txt', 'w') do |f3|
  f3.puts filtered_file
end 
