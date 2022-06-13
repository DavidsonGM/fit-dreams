# frozen_string_literal: true

class GymClass < ApplicationRecord
  belongs_to :teacher, class_name: 'User', inverse_of: :teacher_classes
  has_many :lessons, dependent: :destroy
  has_many :students, through: :lessons, source: :user
  belongs_to :category, optional: true

  validates :name, :start_time, :duration, :description, presence: true
  validates :duration, numericality: { greater_than_or_equal_to: 5, only_integer: true }
  validates :description, length: { minimum: 10 }

  validate :start_time_before_current_date
  validate :user_is_teacher

  def start_time_before_current_date
    return unless start_time && (start_time < Time.zone.today)

    errors.add(:start_time, 'Class cannot start in the past')
  end

  def user_is_teacher
    return if User.find(teacher_id).role.name == 'professor'

    errors.add(:teacher_id, 'User is not a teacher')
  end
end
