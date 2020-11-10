class Api::V1::HomeController < ApplicationController
  def index
    render json: 'Welcome to E-Vote'
  end
end
