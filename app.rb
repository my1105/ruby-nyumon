# encoding: utf-8

require 'sinatra'
require 'sqlite3'
require 'json'
require 'sinatra/activerecord'
require './models/todo'

set :bind, '0.0.0.0'
set :port, 4567
enable :method_override  

before do
  content_type 'text/html', charset: 'utf-8'
end


get '/todos' do
  @todos = Todo.all
  @todos.to_json
end


DB_PATHS = {
  'development' => 'db/development.sqlite3',
  'test' => 'db/test.sqlite3'
}
ENV['RACK_ENV'] ||= 'development'
DB = SQLite3::Database.new(DB_PATHS[ENV['RACK_ENV']])

DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );
SQL


get '/' do
  @todos = DB.execute('SELECT id, title FROM todos')
  erb :todos
end

post '/todos' do
  DB.execute('INSERT INTO todos (title) VALUES (?)', [params[:title]])
  redirect '/'
end

get '/todos/:id/edit' do
  @todo = DB.execute('SELECT id, title FROM todos WHERE id = ?', [params[:id]]).first
  erb :edit
end

put '/todos/:id' do
  DB.execute('UPDATE todos SET title = ? WHERE id = ?', [params[:title], params[:id]])
  redirect '/'
end

delete '/todos/:id' do
  DB.execute('DELETE FROM todos WHERE id = ?', [params[:id]])
  redirect '/'
end

# API
get '/api/todos' do
  content_type :json
  todos = DB.execute('SELECT * FROM todos').map do |row|
    { id: row[0], title: row[1], created_at: row[2] }
  end
  JSON.pretty_generate(todos)
end

get '/api/todos/:id' do
  content_type :json
  todo = DB.execute('SELECT * FROM todos WHERE id = ?', [params[:id]]).first
  JSON.pretty_generate(todo)
end

post '/api/todos' do
  content_type :json
  DB.execute('INSERT INTO todos (title) VALUES (?)', [params[:title]])
  id = DB.last_insert_row_id
  todo = DB.execute('SELECT * FROM todos WHERE id = ?', [id]).first
  JSON.pretty_generate(todo)
end

put '/api/todos/:id' do
  content_type :json
  DB.execute('UPDATE todos SET title = ? WHERE id = ?', [params[:title], params[:id]])
  todo = DB.execute('SELECT * FROM todos WHERE id = ?', [params[:id]]).first
  JSON.pretty_generate(todo)
end

delete '/api/todos/:id' do
  content_type :json
  DB.execute('DELETE FROM todos WHERE id = ?', [params[:id]])
  JSON.pretty_generate({ message: 'TODO deleted' })
end
