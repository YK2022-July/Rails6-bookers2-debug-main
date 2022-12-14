class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :follower_relationships, source: :followed
  has_many :followers, through: :followed_relationships, source: :follower
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user_id)
    follower_relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower_relationships.find_by(followed_id: user_id).destroy
  end

  def followings?(user)
    followings.include?(user)
  end

  def self.looks(search_pattern, word)
    if word == ""
      @user = User.all
    elsif search_pattern == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search_pattern == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search_pattern == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search_pattern == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    end
  end
end
