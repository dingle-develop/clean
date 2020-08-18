; use lib 't/lib'
; use Test::dIngle::Light # -*- perl -*-
# *************************
; use Test2::V0
; plan(6)

; use dIngle::Log

; my $logger = dIngle::Log->get_logger

; is($logger,'dIngle::Log::Testing','Logger is the logger class name')

; ok( no_warnings { $logger->debug('this is a debug message') }, 
    "Debug messages are hidden in testing.")
    
; ok( no_warnings { $logger->info('this is an info message') },
    "Info messages are hidden in testing.")

; is( warning { $logger->warn("This is a warning.") },
    "dIngle::Log::Testing: warn : This is a warning.\n","warnings are visible")

; is( warning { $logger->error('This is a error.') },
    "dIngle::Log::Testing: error : This is a error.\n","error is visible.")
    
; is( warning { $logger->fatal('This is fatal.') },
    "dIngle::Log::Testing: fatal : This is fatal.\n","fatal is visible.")

; done_testing
