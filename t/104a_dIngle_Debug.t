; use lib 't/lib'
; use Test::dIngle::Light

; use strict; use warnings
; use Test2::V0
; plan(4)

; use dIngle::Debug

; use subs 'DEBUG'

; ok(!DEBUG,"Normally debug is off")

; package ABC
; use dIngle::Debug (1)

; use subs 'DEBUG'
; Test2::Tools::Basic::ok(DEBUG,'Debug can be on by import')

; package CDE
; use dIngle::Debug

; use subs 'DEBUG'
; Test2::Tools::Basic::ok(DEBUG,'It still off by default (1).')

; package main

; Test2::Tools::Basic::ok(!DEBUG,'It still off by default (2).')

