# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :teacher_classes, foreign_key: 'teacher_id', class_name: 'GymClass',
                             inverse_of: :teacher, dependent: :nullify
  has_many :lessons, dependent: :destroy
  has_many :student_classes, through: :lessons, source: :gym_class

  validates :name, :birthdate, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validate :birthdate_before_current_date

  def birthdate_before_current_date
    return unless birthdate && (birthdate > Time.zone.today)

    errors.add(:birthdate, 'Birthdate cannot be in the future')
  end
end
