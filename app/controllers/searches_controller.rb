class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @search_model = params[:search_model]

    if @search_model == "User"
      @users = User.looks(params[:search_pattern], params[:word])
    else
      @books = Book.looks(params[:search_pattern], params[:word])
    end
  end
end
