# encoding: utf-8
require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'API: TODOリスト操作', clear_db: true do
  include Rack::Test::Methods

  # Sinatra アプリを返すメソッド
  def app
    Sinatra::Application
  end

  let(:test_todo) { { title: 'テスト用TODO' } }
  let!(:todo_id) do
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
    DB.last_insert_row_id
  end

  describe 'GET /api/todos/:id' do
    it '指定したIDのTODOを取得できること' do
      get "/api/todos/#{todo_id}"

      # ステータスコードの確認
      expect(last_response.status).to eq 200

      # JSON 形式で返っているか確認
      expect(last_response.content_type).to include('application/json')

      # JSON をパース
      todo = JSON.parse(last_response.body)

      # 取得した内容を確認
      expect(todo[0]).to eq(todo_id)       # SQLite の行は配列形式なので 0 番目が id
      expect(todo[1]).to eq(test_todo[:title]) # 1 番目が title
    end
  end
end
