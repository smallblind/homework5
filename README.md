This project is designed to be used on a linux/unix environment with Ruby 1.9.3+, Bundler, and installed.


Instructions to Install Bundler
sudo gem install bundler

To set up:
bundle install

To run:
ruby bloom_filter.rb "test_paragraph.txt" 10000 5

* Replace test_paragraph.txt with the name of the desired input file
* Replace 10000 with the desired size of the bit array
* Replace 5 with the desired number of hash functions

Output:
The filtered text output of your input file can be found in filtered_text.txt.

