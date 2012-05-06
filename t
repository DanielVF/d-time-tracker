#!/usr/bin/env ruby
# Daniel Von Fange
# Matthias Derer
# Christian Genco

# Configuration
$data_dir = File.expand_path('~/Dropbox/.ttimetracker')

@custom_time = nil
if i = ARGV.index("--at")
  require 'chronic' # only load chronic if you need it
  ARGV.delete_at(i) # remove "--at"
  @custom_time = Chronic.parse(ARGV[i], :context => :past)
  ARGV.delete_at(i) # remove the custom time argument
end

# Program starts
require 'time'
data_dir = $data_dir
input = $*.join(' ').strip

# create the data directory if it doesn't exist
`/usr/bin/env mkdir -p #{data_dir}`

def current_task
    return task("current")
end

def last_task
    return task("last")
end

def task(whichtask)
  return nil if ! File.exists?("#{$data_dir}/#{whichtask}")
  File.open("#{$data_dir}/#{whichtask}",'r') do |f|
    line = f.gets
    return if line.nil?
    # p "line: #{line}"
    start, task = line.strip.split(",").map(&:strip)
    start = Time.parse(start)
    end_time = @custom_time || Time.new
    minutes = ((end_time - start).to_f / 60).ceil
    # p "task(#{whichtask}) -> [start: #{start}, task:#{task}, end_time: #{end_time}, minutes: #{minutes}]"
    return start, task, end_time, minutes
  end
end

def format_time(t)
  # http://www.ruby-doc.org/core-1.9.3/Time.html#method-i-strftime
  t.strftime("%H:%M:%S")
end

def set_current_task(task)
  `/usr/bin/env mkdir -p #{$data_dir}`
  if File.exists?("#{$data_dir}/last")
    File.unlink("#{$data_dir}/last")
  end
  File.open("#{$data_dir}/current",'w') do |f|
    f.puts "#{format_time(@custom_time || Time.now)}, #{task.strip}"
  end
end

def h_m(minutes)
  hours = (minutes.to_i / 60).floor
  hours_minutes = "#{hours}:#{'%02d' % (minutes % 60)}"
end

# And now for the real work...

# Show current task
if input.empty?
  if ! current_task
    puts "You're not working on anything"
    exit
  end
    
  start, task, end_time, minutes = current_task
  puts "In progress: #{task} (#{h_m(minutes)})"
  exit
end

if input.match(/^(e|edit)$/)
  # batch edit the logs instead
  `subl #{$data_dir}`
  # if ! ENV['EDITOR']
  #     puts "No EDITOR environment varible defined"
  #     exit
  # end
  
  # `#{ENV['EDITOR']} #{data_dir}/current`
  exit
end

if input.match(/^(r|resume)$/)
  if ! last_task
    puts "No task to resume"
    exit
  end

  start, task, end_time, minutes = last_task
  set_current_task(task)
  puts "Resuming #{task}"
  exit

end

# If there's a current task, record the time spent on it.
if current_task
  start, task, end_time, minutes = current_task
  dir = "#{$data_dir}/" + Time.now.strftime("%Y/%m_%b/")
  `/usr/bin/env mkdir -p #{dir}`
  File.open("#{dir}/#{start.strftime('%Y-%m-%d')}.csv",'a') do |f|
    f.puts "#{format_time start}, #{format_time end_time}, #{task}"
  end
  
  puts("Finished: #{task} (#{h_m(minutes)})")
  
  File.rename("#{data_dir}/current", "#{data_dir}/last")
end

# Unless we are only marking a task done, start a new task
if ! input.match(/^(d|done|stop|)$/)
  set_current_task(input)
  puts "Started: #{input} (#{@custom_time ? format_time(@custom_time) : 'now'})"
end