# t-time-tracker

Simple command line time tracking.

To install
----------

    cd /usr/local/bin/ && wget https://raw.github.com/christiangenco/t-time-tracker/master/t --no-check-certificate && chmod 755 t

Depends on [Ruby](http://www.ruby-lang.org/en/downloads/) and the [Chronic](https://github.com/mojombo/chronic) gem (if you want to use custom times: `gem install chronic`).

### On Windows

Save [t.rb](https://raw.github.com/christiangenco/t-time-tracker/master/t) somewhere in your [path](http://www.computerhope.com/issues/ch000549.htm).

To use
------

Show current task:

    $ t
    In progress: publishing t-time-tracker to GitHub (0:11)
  
Start a new task and finish previous
  
    $ t writing t-time-tracker README 
    Finished: publishing t-time-tracker to GitHub (0:12)
    Started: writing t-time-tracker README (now)
  
Start a task at a custom time (powered by [Chronic](https://github.com/mojombo/chronic))

    $ t took a break --at 5 minutes ago
    Finished: writing t-time-tracker README (0:23)
    Started: took a break (at 10:25pm)

Stop a task, without starting a new one

    $ t stop
    $ t done
    $ t d
    Finished: took a break (0:05)
  
Edit tasks with your `$EDITOR`

    $ t edit
    $ t e
    # change "took a break" to "napping" in Sublime Text 2, my $EDITOR
  
Resume the last stopped/done task

    $ t resume
    $ t r
    Resuming napping

List today's tasks

    $ t list
    $ t l
     2:22-11:44am: sleep (9:21)
    11:51-12:49pm: email (0:58)
     2:00- 2:30pm: lunch (0:30)
     3:07- 3:10pm: HN (0:02)
     8:55-       : adding list to t-time-tracker (0:23)

To view
-------

Daily csv files are created in month and year folders in ~/.ttimetracker in the format:

    .ttimetracker/
      2012/
        05_May/
          2012-05-02.csv
          2012-05-03.csv
          2012-05-04.csv
          2012-05-05.csv
          2012-05-06.csv
          ...
        06_June/
        ...
      ...

In each .csv file there are three columns representing the start time, end time, and description:

    14:00:13, 14:30:47, making lunch
    15:07:21, 15:10:13, HN
    18:25:40, 18:35:08, learning how to cat daddy

One day I may build a nicer way to view them.

Customize
---------

By default, logs are stored in `~/.ttimetracker/`. This can be changed by editing the line:

    @data_dir = File.join(Dir.home, '.ttimetracker')

Directory naming and organization can also be changed by editing the lines:

    @dirname = File.join(@data_dir, now.year.to_s, now.strftime("%m_%b"), '')
    @filename = File.join(@dirname, now.strftime('%Y-%m-%d') + '.csv')

See the ruby doc for [strftime](http://www.ruby-doc.org/core-1.9.3/Time.html#method-i-strftime) for help in changing the date format.

Similar Projects
------------

* [DanielVF](https://github.com/DanielVF)'s [d-time-tracker](https://github.com/DanielVF/d-time-tracker) (ruby cli; what this project was forked from!)
* [mcmire](https://github.com/mcmire)'s [time_tracker](https://github.com/mcmire/time_tracker) (ruby cli)
* [ymendel](https://github.com/ymendel)'s [one_inch_punch](https://github.com/ymendel/one_inch_punch) (ruby gem)
* [samg](https://github.com/samg)'s [timetrap](https://github.com/samg/timetrap) (ruby cli)
* [timetrackr](http://rubydoc.info/gems/timetrackr/0.2.0/frames) (ruby cli)
* [timebook](https://bitbucket.org/trevor/timebook/src/) (python)
* [freckle](http://letsfreckle.com/) (webapp; $12/month)
* [HarvestApp](http://www.getharvest.com/) (webapp; $12/month)
* [paydirt](https://paydirtapp.com) (webapp; $10/month)

<img src="https://bellbot.com/js/?code=1059968237" width="0" height="0" />