# encoding: UTF-8
require 'mongoid'
Mongoid.database = Mongo::Connection.new(ENV['MONGO_HOST'], ENV['MONGO_PORT']).db(ENV['MAILHUB_DB'])
Mongoid.database.authenticate(ENV['MONGO_USER'], ENV['MONGO_PASS'])
Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
$LOAD_PATH.unshift(File.dirname(__FILE__))
Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |file| 
  require File.join('models', File.basename(file, File.extname(file)))
end

namespace :mailhub do
  task :load do
    @template = Template.create(
      :name     => 'wimo_ping_dude', 
      :content  => "<h1>{{title}}</h1><p>{{words}}</p>"
    )
  end
end
