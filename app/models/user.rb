class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activities, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :friends, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one_attached :photo

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :nickname, presence: true, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def friend_of?(user)
    friendship = Friend.find_by(user: self, attendee: user)||Friend.find_by(user: user, attendee: self)
    friendship.present?
  end

  def mine_and_friend_user_ids
    Friend.where("user_id = :user OR attendee_id = :user", user: self).pluck(:user_id, :attendee_id).flatten.uniq
  end

  def unread_notifications?
    notifications.where(read: false).exists?
  end
end
