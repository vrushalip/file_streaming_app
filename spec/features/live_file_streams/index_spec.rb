require 'rails_helper'

RSpec.describe "Live File Stream index page", type: :feature do
  it "can see all logs" do
    visit "/live_file_streams"

    binding.pry
  end
end