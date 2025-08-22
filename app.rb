require 'sinatra'
require 'sqlite3'
enable :method_override

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

get '/todos' do
  @todos = DB.execute('SELECT id, title FROM todos')
  erb :todos
end

put '/todos/:id' do
  DB.execute('UPDATE todos SET title = ? WHERE id = ?', [params[:title], params[:id]])
  redirect '/todos'  
end

delete '/todos/:id' do
  DB.execute('DELETE FROM todos WHERE id = ?', [params[:id]])
  redirect '/todos'
end

