require 'rails_helper'

RSpec.describe LiveFileStreamsController, type: :controller do
  describe '#log_file' do
    it 'displays last 10 records from log file' do
      allow_any_instance_of(Filewatcher).to receive(:watch).and_return(['1', '2'])

      get :log_file
      expect(response.body).to include("data: 1")
      expect(response.body).to include("event: message")
      expect(response.headers).to match(hash_including('Content-Type' => 'text/event-stream'))
    end

    it 'displays updated contents' do
      allow_any_instance_of(Filewatcher).to receive(:watch).and_return(['1', '2'])

      get :log_file
      File.open(Rails.root.join('log/sample.log'), 'a') do |file|
        file.puts "Added to file"
      end
      get :log_file
      expect(response.body).to include("data: Added to file")
    end
  end
end