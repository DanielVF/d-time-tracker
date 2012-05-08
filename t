#!/usr/bin/env ruby
# Daniel Von Fange
# Matthias Derer
# Christian Genco
require 'time'

# Configuration
now       = Time.now
@data_dir = File.join(Dir.home, '.ttimetracker')
@dirname  = File.join(@data_dir, now.year.to_s, now.strftime("%m_%b"), '')
@filename = File.join(@dirname, now.strftime('%Y-%m-%d') + '.csv')

# recursively create directories if they doesn't exist
def mkdir(dir)
  mkdir(File.dirname dir) unless File.dirname(dir) == dir
  Dir.mkdir(dir) unless dir.empty? || File.directory?(dir)
end
mkdir @dirname

if i = ARGV.index("--at")
  require 'chronic' # only load chronic if you need it
  ARGV.delete_at(i) # remove "--at"
  @custom_time_in_words = ARGV[i..-1].join(' ')
  @custom_time          = Chronic.parse(@custom_time_in_words, :context => :past)
end

# Program starts
input = $*.join(' ').sub(@custom_time_in_words || '', '').strip

def task(whichtask)
  task_filename = File.join(@data_dir, whichtask)
  return nil unless File.exists?(task_filename)
  File.open(task_filename,'r') do |f|
    line = f.gets
    return if line.nil?
    start, task = line.strip.split(",").map(&:strip)
    start       = Time.parse(start)
    end_time    = @custom_time || Time.new
    minutes     = ((end_time - start).to_f / 60).ceil
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
  last = File.join(@data_dir, "last")
  File.unlink(last) if File.exists?(last)
  File.open(File.join(@data_dir, "current"),'w') do |f|
    f.puts "#{format_time(@custom_time || Time.now)}, #{task.strip}"
  end
end

def h_m(minutes)
  hours         = minutes.to_i / 60
  hours_minutes = "#{hours}:#{'%02d' % (minutes % 60)}"
end

# And now for the real work...

# Show current task
if input.empty?
  unless current = current_task
    STDERR.puts "You're not working on anything"
    exit
  end
    
  start, task, end_time, minutes = current
  STDERR.puts "In progress: #{task} (#{h_m(minutes)})"
  exit
end

if input.match(/^(e|edit)$/)
  STDERR.puts "opening #{@data_dir}"

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
    start, end_time       = Time.parse(start), Time.parse(end_time)
    minutes               = (end_time - start)/60.0
    puts "#{start.strftime('%l:%M')}-#{end_time.strftime('%l:%M%P')}: #{task} (#{h_m minutes})"
  end
  if current = current_task
    start, task, end_time, minutes = current
    puts "#{start.strftime('%l:%M')}-       : #{task} (#{h_m minutes})"
  end
  exit
end

if input.match(/^(r|resume)$/)
  unless last_task
    STDERR.puts "No task to resume"
    exit
  end

  start, task, end_time, minutes = last_task
  set_current_task(task)
  STDERR.puts "Resuming #{task}"
  exit
end

# If there's a current task, record the time spent on it.
if current = current_task
  start, task, end_time, minutes = current

  File.open(@filename,'a') do |f|
    f.puts "#{format_time start}, #{format_time end_time}, #{task.strip}"
  end
  
  STDERR.puts("Finished: #{task} (#{h_m(minutes)})")
  File.rename(File.join(@data_dir, 'current'), File.join(@data_dir, 'last'))
end

# Unless we are only marking a task done, start a new task
if ! input.match(/^(d|done|stop|end|)$/)
  set_current_task(input)
  STDERR.puts "Started: #{input} (#{@custom_time ? 'at ' + @custom_time.strftime('%-l:%M%P') : 'now'})"
end