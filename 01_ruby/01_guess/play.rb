require 'open3'

# default to playing with a limit of 10
limit = (ARGV.shift || "10").to_i

# open a child process for the game using the Open3 library
status =
  Open3.popen3("ruby guess.rb #{limit}") do |child_stdin, child_stdout, child_stderr, wait_thr|
    puts ">>> pid        : #{ wait_thr.pid }"       # report the child pid for informational purposes
  
    finished = false                                # we're just getting started!
    i = 1                                           # let's start with a simple guess

    until finished || (i > limit)                   # keep looping until we're done
      inline = child_stdout.readline.strip          # get input from the game process

      unless inline.match(/GUESS/)                  # make sure the game is asking what we expect
        puts "Unexpected input! #{inline}"
        exit                                        # if not ... exit
      end

      puts "< " + inline                            # report the input from game
      puts "> " + i.to_s                            # report the guess we're about to make
      child_stdin.puts i                            # send the guess to the game process
      response = child_stdout.readline.strip        # get the result from the game process
      puts "< " + response                          # report the result
      finished = response.match(/:exiting/)         # if the response includes ':exiting', we're done

      i += 1
    end
    puts ">>> exitstatus : #{ wait_thr.value }"
  end

