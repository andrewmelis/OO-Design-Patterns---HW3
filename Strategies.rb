#using ruby Procs instead of Strategy classes
require 'fileutils'

CONSTANT_PRESSURE = lambda do |context|
  @@t = 0


