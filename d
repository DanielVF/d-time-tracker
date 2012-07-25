#!/usr/bin/env ruby
# Daniel Von Fange
# Matthias Derer


# Configuration

$data_dir = File.expand_path('~/.dtimetracker')

# Program starts
require 'time'
data_dir = $data_dir
input = $*.join(' ').strip

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
    
    start, task = line.strip.split("\t")
    start = Time.parse(start)
    end_time = Time.new
    minutes = ((end_time - start).to_f / 60).ceil
    return start, task, end_time, minutes
  end
end

def set_current_task(task)
  `/usr/bin/env mkdir -p #{$data_dir}`
  if File.exists?("#{$data_dir}/last")
    File.unlink("#{$data_dir}/last")
  end
  File.open("#{$data_dir}/current",'w') do |f|
    f.puts "#{Time.now}\t#{task.gsub(/\n/,' ')}"
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
  puts "In progress\t#{h_m(minutes)}\t#{task}"
  exit
end

if input.match(/^(e|edit)$/)
  if ! ENV['EDITOR']
      puts "No EDITOR environment varible defined"
      exit
  end
  
  `#{ENV['EDITOR']} #{data_dir}/current`
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

  `/usr/bin/env mkdir -p #{$data_dir}/#{Time.now.year}`
  File.open("#{data_dir}/#{Time.now.year}/#{start.strftime('%Y-%m-%d')}.txt",'a') do |f|
    f.puts "#{start}\t#{end_time}\t#{task}\t#{minutes}"
  end
  
  puts("Finished\t#{h_m(minutes)}\t#{task}")
  
  File.rename("#{data_dir}/current", "#{data_dir}/last")
end

# Unless we are only marking a task done, start a new task
if ! input.match(/^(d|done|stop|)$/)
  set_current_task(input)
  puts "Started \tnow\t#{input}"
end

