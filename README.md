# Simple command line time tracking.


To install
----------

    cd /usr/local/bin/test && wget https://raw.github.com/christiangenco/t-time-tracker/master/t  --no-check-certificate && chmod 755 t

By default, logs are stored in `~/Dropbox/.ttimetracker`, but this can easily be changed in the Configuration section at the top of `t`.

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

    $ t took a break --at "5 minutes ago"
    Finished: writing t-time-tracker README (0:23)
    Started: took a break (19:25:48)

Stop a task, without starting a new one

    $ t stop
    $ t done
    $ t d
    Finished: took a break (0:05)
  
Edit tasks with your `$EDITOR`

    $ t edit
    $ t e
    # change "took a break" to "working" in Sublime Text 2, my $EDITOR
  
Resume the last stopped/done task

    $ t resume
    $ t r
    Resuming working

To view
-------

Daily csv files are created in month and year folders in ~/Dropbox/.ttimetracker in the format:

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