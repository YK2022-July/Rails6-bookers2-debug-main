class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search_pattern, word)
    if search_pattern == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search_pattern == "forward_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search_pattern == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search_pattern == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end
end
