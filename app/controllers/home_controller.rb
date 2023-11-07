class HomeController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # Display Home page
  def index

  end

end
