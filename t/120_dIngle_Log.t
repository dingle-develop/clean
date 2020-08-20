; use lib 't/lib'
; use Test::dIngle::Light # -*- perl -*-
# *************************
; use Test::More
; use Test::Output
; plan(tests => 7)

; use dIngle::Log

; my $logger = dIngle::Log->get_logger

; is($logger,'dIngle::Log::Testing','Logger is the logger class name')

; output_is( sub{ $logger->debug('this is a debug message') }, '', '',
    "Debug messages are hidden in testing.")
    
; output_is( sub{ $logger->info('this is an info message') }, '', '',
    "Info messages are hidden in testing.")

; output_is( sub{ $logger->warn("This is a warning.") },
    '', "# dIngle::Log::Testing: warn : This is a warning.\n",
    "warnings are visible")

; output_is( sub{ $logger->error('This is a error.') },
    '', "# dIngle::Log::Testing: error : This is a error.\n",
    "error is visible.")
    
; output_is( sub{ $logger->fatal('This is fatal.') },
    '', "# dIngle::Log::Testing: fatal : This is fatal.\n",
    "fatal is visible.")
    
; output_is( sub{ $logger->unknown_method('Call me right now!') },
    '', "# dIngle::Log::Testing\n"
      . "# UNKNOWN LOGLEVEL: unknown_method\n"
      . "# MESSAGE: Call me right now!\n"
    , "Log for unknown log method")

; done_testing
