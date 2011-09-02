What is it
----------

It records lines of text and the times at which you started and completed
entering them.  Entering a line of text containing only a single period will
finish a session of adding text.

You can view your monologue complete with timestamps, too.

Why'd you write it?
-------------------

* to make something slightly less trivial in Haskell

An example
----------

    allkinds:pb ellis$ monologue make stream-o-consciousness
    I would like to think
    that this program
    is perfect
    for making
    very
    very
    bad
    poetry
    .
    allkinds:pb ellis$ monologue add stream-o-consciousness 
    yes,
    terrible poetry.
    .
    allkinds:pb ellis$ monologue read stream-o-consciousness 
    ================================================================================
    stream-o-consciousness
    ================================================================================
    2011 09/01 23:15:39 I would like to think
                     44 that this program
                     46 is perfect
                     48 for making
                     50 very
                     52 very
                     53 bad
                     54 poetry
                     56 .
                  16:11 yes,
                     14 terrible poetry.
                     20 .
    allkinds:pb ellis$ 


How to build it
---------------

Have the Haskell platform installed and run

    cabal install --prefix=$HOME --user

in this directory.  This should create a monologue executable in something
like your ~/bin directory.

How to run it
-------------

You can make new monologues and either read or add to existing monologues.

`monologue make my_soliloquy` creates the file my_soliloquy and starts adding
text to it.

`monologue add my_soliloquy` adds text to my_soliloquy.

`monologue read my_soliloquy` prints the text recorded in my_soliloquy,
complete with timestamps.
