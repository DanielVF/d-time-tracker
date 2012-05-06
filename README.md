# Simple command line time tracking.


To install
----------

    sudo chmod 755 d
    sudo cp d /usr/local/bin

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

Daily files are created in month and year folders in ~/Dropbox/.ttimetracker

One day I may build a nice way to view them.

