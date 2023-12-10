require 'file_streaming_app/log_file'

class LiveFileStreamsController < ApplicationController
  include ActionController::Live

  def index;end

  def log_file
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Last-Modified'] = Time.now.httpdate

    sse = SSE.new(response.stream, event: "message")

    log_file_path = Rails.root.join('log/sample.log').to_s

    file = FileStreamingApp::LogFile.new
    file_lines = file.added_lines(log_file_path)
    file_lines.each do |line|
      sse.write(line, event: 'message')
    end

    Filewatcher.new([log_file_path]).watch do |changes|
      changes.each do |_filename, event_type|
        next unless event_type.to_s.eql?('updated')
  
        file_lines = file.added_lines(log_file_path)
        file_lines.each do |line|
          sse.write(line, event: 'message')
        end
      end
    end
  ensure
    sse.close
  end
end
