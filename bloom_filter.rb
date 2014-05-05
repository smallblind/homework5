require 'murmurhash3' # Murmur hash gem


$input_file = ARGV[0] # Read the input file name from the first command line argument
$bit_array_length = ARGV[1].to_i # The length of the bit array for the filter
$num_hash_functions = ARGV[2].to_i # The number of hash functions used to hash words
$bloom_filter = Array.new($bit_array_length, false) # Create bloom filter of inputed size
filtered_file = String.new("") # File after it has been examined and the matches replaced
$positive_matches = 0


# Add a word to the bloom filter. For use on auto-words.txt
def addto_bloom_filter(word)
  for i in 0..$num_hash_functions
    hash_value = MurmurHash3::V32.str_hash(word, i)  % $bit_array_length
    $bloom_filter[hash_value] = true
  end
end

# Check if a word is contained in a bloom filter
def bloom_filter_contains (word)
  for i in 0..$num_hash_functions
    hash_value = MurmurHash3::V32.str_hash(word, i)  % $bit_array_length
    if $bloom_filter[hash_value] == false
      return false
    end
  end
  $positive_matches = $positive_matches + 1 
  return true # No false hashes in the filter means this is a match
end

# Read "illegal" auto word from the given text file, and hash into the bloom filter
File.open('auto-words.txt', 'r') do |f1|  
  while line = f1.gets

    # Split the line into individual words
    split_string = line.split(' ')

    # Add each word to the bloom filter
    split_string.each do |word|
      addto_bloom_filter(word)
    end
  end
end
  
# Read the given input file to identify and replace postive matches for illegal words.
File.open($input_file, 'r') do |f2|
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

        # If the word is present in the bloom filter, the filter it out of the file
        if bloom_filter_contains(word)
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

# Print stats
puts "\n"
puts "Bit Array Length: "
puts $bit_array_length
puts "\n"
puts "Number of Hash Functions: "
puts $num_hash_functions
puts "\n"
puts "Positive Matches Found in " + $input_file + ": "
puts $positive_matches
puts "\n"
puts "You can view the filtered output in filtered_text.txt!"
puts "\n"
