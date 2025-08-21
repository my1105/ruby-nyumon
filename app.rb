require './db/todos'
require 'sinatra'

get '/todos' do
  @todos = DB.execute('SELECT title FROM todos').map(&:first)
  erb :todos
end
