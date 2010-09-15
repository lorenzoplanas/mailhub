# content: utf-8
require 'sinatra/base'
require 'mongoid'

Mongoid.database = Mongo::Connection.new(ENV['MONGO_HOST'], ENV['MONGO_PORT']).db(ENV['MAILHUB_DB'])
Mongoid.database.authenticate(ENV['MONGO_USER'], ENV['MONGO_PASS']) if ENV['MONGO_USER'].present?
$LOAD_PATH.unshift(File.dirname(__FILE__))
Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |file| 
  require File.join('models', File.basename(file, File.extname(file)))
end

class MailHub < Sinatra::Base
  set :environment,           :development
  set :app_file,              __FILE__
  set :root,                  File.dirname(__FILE__)
  set :public,                Proc.new { File.join(root, "public") }
  enable                      :sessions, :static, :method_override

  before { p params }

  get   '/:app/:template' do prepare_message end
  post  '/:app/:template' do prepare_message end

  helpers do
    def prepare_message
      Message.prepare(
        :template => "#{params[:app]}_#{params[:template]}",
        :to       => [params.delete('to')],
        :from     => params.delete('from'), 
        :subject  => params.delete('subject'), 
        :fillers  => params
      )
    end
  end
end
