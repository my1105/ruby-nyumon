# encoding: utf-8
require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'RSpec を使用してテストを書こう', clear_db: true do
  it 'station14_spec.rb`指定したIDのTODOが取得できること` にテストが実装されていること' do
    station14_spec_file_path = 'spec/station14/station14_spec.rb'

    expect(File.exist?(station14_spec_file_path)).not_to be_falsey

    file_content = File.read(station14_spec_file_path, encoding: 'UTF-8')
    it_block_regex = /it\s+['"]指定したIDのTODOを取得できること['"]\s+do\s*\n?(.*?)\n?\s*end/m
    match_data = file_content.match(it_block_regex)

    expect(match_data).not_to be_nil

    it_block_content = match_data[1]
    content_lines = it_block_content.lines.map(&:strip)
    non_comment_lines = content_lines.reject { |line| line.empty? || line.start_with?('#') }

    expect(non_comment_lines).not_to be_empty
  end

  it 'station14_spec.rbのテストが通ること' do
    expect { load 'spec/station14/station14_spec.rb' }.not_to raise_error
  end
end
