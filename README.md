# Simple command line time tracking.


To install
----------

    cd /usr/local/bin/test && wget https://raw.github.com/christiangenco/t-time-tracker/master/t  --no-check-certificate && chmod 755 t

To use
------

Show current task:

    t
  
Start a new task and finish previous
  
    t <What you're working on>
  
Start a task at a custom time (powered by [Chronic](https://github.com/mojombo/chronic))

    t <What you're working on> --at "5 minutes ago"

Stop a task, without starting a new one

    t stop
    t done
    t d
  
Edit tasks in Sublime Text 2 (define a custom editor on line 84)

    t edit
    t e
  
Resume the last stopped/done task

    t resume
    t r

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

One day I may build a nice way to view them.