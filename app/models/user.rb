class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :active_relationships, class_name: 'Relationship',
  foreign_key: 'follower_id',
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship',
  foreign_key: 'followed_id',
    dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  attachment :profile_image, destroy: false

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where('name LIKE?', "#{word}")
    elsif search == "forword_match"
      @user = User.where('name LIKE?', "#{word}%")
    elsif search == "backword_match"
      @user = User.where('name LIKE?', "%#{word}")
    elsif search == "partial_match"
      @user = User.where('name LIKE?', "%#{word}%")
    else
      @user = User.all
    end
  end

end
