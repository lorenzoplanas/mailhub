# encoding: UTF-8
require 'mongoid'
require 'rspec'
#require 'qsupport'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
Mongoid.configure { |config| config.master = Mongo::Connection.new.db("mailhub_test") }
MODELS = File.join(File.dirname(__FILE__), "../models")
Dir[ File.join(MODELS, "*.rb") ].sort.each { |file| require file }
Rspec.configure do |config|
  config.after :suite do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
