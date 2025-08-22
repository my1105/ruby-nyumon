require 'sinatra'
require 'sqlite3'

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

get '/todos' do
  @todos = DB.execute('SELECT title FROM todos').map { |row| row[0] }
  erb :todos
end


post '/todos' do
  DB.execute('INSERT INTO todos (title) VALUES (?)', [params[:title]])
  redirect '/'
end


get '/' do
  @todos = DB.execute('SELECT title FROM todos').map { |row| row[0] }
  erb :todos
end
