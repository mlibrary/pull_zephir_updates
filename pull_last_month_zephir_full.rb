#!/usr/bin/env ruby
require_relative 'lib/pull_from_zephir'
require 'dotenv'
Dotenv.load('.env')

PullFullFromLastMonthFromZephir.new.run
