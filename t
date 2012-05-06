#!/usr/bin/env ruby
# Daniel Von Fange
# Matthias Derer
# Christian Genco
require 'time'

# Configuration
@data_dir = File.expand_path('~/Dropbox/.ttimetracker')
@dirname = "#{@data_dir}/" + Time.now.strftime("%Y/%m_%b/")
@filename = "#{@dirname}#{Time.new.strftime('%Y-%m-%d')}.csv"

# create directories if they doesn't exist
`/usr/bin/env mkdir -p #{@data_dir} #{@dirname}`

@custom_time = nil
if i = ARGV.index("--at")
  require 'chronic' # only load chronic if you need it
  ARGV.delete_at(i) # remove "--at"
  @custom_time = Chronic.parse(ARGV[i], :context => :past)
  ARGV.delete_at(i) # remove the custom time argument
end

# Program starts
input = $*.join(' ').strip

def task(whichtask)
  return nil if ! File.exists?("#{@data_dir}/#{whichtask}")
  File.open("#{@data_dir}/#{whichtask}",'r') do |f|
    line = f.gets
    return if line.nil?
    # p "line: #{line}"
    start, task = line.strip.split(",").map(&:strip)
    start = Time.parse(start)
    end_time = @custom_time || Time.new
    minutes = ((end_time - start).to_f / 60).ceil
    # p "task(#{whichtask}) -> [start: #{start}, task:#{task}, end_time: #{end_time}, minutes: #{minutes}]"
    return [start, task, end_time, minutes]
  end
end
def current_task; task("current"); end
def last_task; task("last"); end

def format_time(t)
  # http://www.ruby-doc.org/core-1.9.3/Time.html#method-i-strftime
  t.strftime("%H:%M:%S")
end

def set_current_task(task)
  `/usr/bin/env mkdir -p #{@data_dir}`
  if File.exists?("#{@data_dir}/last")
    File.unlink("#{@data_dir}/last")
  end
  File.open("#{@data_dir}/current",'w') do |f|
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
  if !current_task
    puts "You're not working on anything"
    exit
  end
    
  start, task, end_time, minutes = current_task
  puts "In progress: #{task} (#{h_m(minutes)})"
  exit
end

if input.match(/^(e|edit)$/)
  puts "opening #{@data_dir}"

  if ! ENV['EDITOR']
      puts "No EDITOR environment varible defined"
      puts "Set your EDITOR in your .bashrc or .zshrc file by adding one of these lines:"
      puts "\texport EDITOR='vim' # for vim"
      puts "\texport EDITOR='subl' # for Sublime Text 2"
      puts "\texport EDITOR='mate' # for Textmate"
      exit
  end
  
  # batch edit the logs instead
  `#{ENV['EDITOR']} #{@data_dir}`
  exit
end

if input.match(/^(l|list)$/)
  File.open(@filename).each do |line|
    start, end_time, task = line.split(/, ?/).map(&:strip)
    start, end_time = Time.parse(start), Time.parse(end_time)
    minutes = (end_time - start)/60.0
    puts "#{start.strftime('%l:%M')}-#{end_time.strftime('%l:%M%P')}: #{task} (#{h_m minutes})"
  end
  if current = current_task
    start, task, end_time, minutes = current
    puts "#{start.strftime('%l:%M')}-       : #{task} (#{h_m minutes})"
  end
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
if current = current_task
  start, task, end_time, minutes = current

  File.open(@filename,'a') do |f|
    f.puts "#{format_time start}, #{format_time end_time}, #{task.strip}"
  end
  
  puts("Finished: #{task} (#{h_m(minutes)})")
  
  File.rename("#{@data_dir}/current", "#{@data_dir}/last")
end

# Unless we are only marking a task done, start a new task
if ! input.match(/^(d|done|stop|)$/)
  set_current_task(input)
  puts "Started: #{input} (#{@custom_time ? 'at ' + @custom_time.strftime('%l:%M%P') : 'now'})"
end