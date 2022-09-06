class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @search_model = params[:search_model]
    @word = params[:word]

    if @search_model == "user"
      @users = User.looks(params[:search_pattern], params[:word])
    else
      @books = Book.looks(params[:search_pattern], params[:word])
    end
  end
end
