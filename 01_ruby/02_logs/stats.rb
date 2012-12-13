
filename = ARGV.shift                   # get a filename from the command line arguments

unless filename                         # we can't work without a filename
  puts "no filename specified!"
  exit
end

urls = Array.new
users = Array.new
dates = Array.new
arrayOfVals = Array.new
lines = 0                               # a humble line counter
unique_users = 0                # someday, this will work
unique_pages = 0                # someday, this will work
most_active_day = "unknown"             # someday, this will work
most_active_user = "unknown"            # someday, this will work
most_active_page = "unknown"            # someday, this will work
unique_days = 0

open(filename).each_with_index  do |m, i|
  next if i == 0  		# ignore the top line
  m.chomp!                              # remove the trailing newline

  values = m.split(",")           # split comma-separated fields into a values array

  values.each { |x| arrayOfVals.push x }
  # ...

  lines += 1                            # bump the counter
end

h1 = Hash.new(0) # table of users
h2 = Hash.new(0) # table of URLs
h3 = Hash.new(0) # table of dates

urls = arrayOfVals.select.with_index{|_,i| (i+1) % 3 == 0}   # URLs are every 3rd element in the array of all values
# urls.push arrayOfVals.delete(|i| (i+1) % 3 == 0)   # why doesn't this work?

#users = arrayOfVals.select.with_index{|_,i| (i+1) % 2 == 0}  # users are every other element in the array of all vals
arrayOfVals.each { |x| users.push x if x.chars.first.eql?("U")}
arrayOfVals.each { |x| dates.push x if x.chars.first.eql?("2")}

users.each { | v | h1.store(v, h1[v]+1) }
urls.each { | v | h2.store(v, h2[v]+1) }
dates.each { | v | h3.store(v, h3[v]+1) }

puts h1
puts h2
puts h3

=begin
h.keys.sort.each do |key|
  unique_users += 1 if key.chars.first.eql?("U")
  unique_pages += 1 if key.chars.first.eql?("/")
  unique_days += 1 if key.chars.first.eql?("2")
end
=end

unique_users = h1.length
unique_pages = h2.length

most_active_user = h1.max_by{|k,v| v}
most_active_page = h2.max_by{|k,v| v}
most_active_day = h3.max_by{|k,v| v}


puts "total lines: #{lines}"                  # output stats
puts "unique users: #{unique_users}"          # someday, this will work
puts "unique pages: #{unique_pages}"          # someday, this will work
puts "most active day: #{most_active_day}"    # someday, this will work
puts "most active user: #{most_active_user}"  # someday, this will work
puts "most active page: #{most_active_page}"  # someday, this will work
