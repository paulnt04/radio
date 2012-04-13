require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'environment')

configure do
  connections = []
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
get '/' do
  erb :index
end

get /\/api\/room\/\d+/ do
  stream(:keep_open) {|out| connections << out}
end

post /\/api\/room\/\d+/ do
  connections.each {|out| out << params[:message] << "\n" }
end
