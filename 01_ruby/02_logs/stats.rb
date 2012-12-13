
filename = ARGV.shift                   # get a filename from the command line arguments

unless filename                         # we can't work without a filename
  puts "no filename specified!"
  exit
end

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

h = Hash.new(0)

arrayOfVals.each { | v | h.store(v, h[v]+1) }

puts h
=begin
h.keys.sort.each do |key|
  puts key
end
=end
h.keys.sort.each do |key|
  unique_users += 1 if key.chars.first.eql?("U")
  unique_pages += 1 if key.chars.first.eql?("/")
  unique_days += 1 if key.chars.first.eql?("2")
end



puts "total lines: #{lines}"                  # output stats
puts "unique users: #{unique_users}"          # someday, this will work
puts "unique pages: #{unique_pages}"          # someday, this will work
puts "most active day: #{most_active_day}"    # someday, this will work
puts "most active user: #{most_active_user}"  # someday, this will work
puts "most active page: #{most_active_page}"  # someday, this will work
