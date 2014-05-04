words = String.new("")

File.open('auto-words.txt', 'r') do |f1|  
  while line = f1.gets  
    words = words + line  
  end  
end  
  
# Create a new file and write to it  
File.open('bad_words.txt', 'w') do |f2|  
  f2.puts words  
end  