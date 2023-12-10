class PagesController < ApplicationController
  def home
    @lines = File.readlines(Rails.root.join("log", "sample.log"))
  end
end
