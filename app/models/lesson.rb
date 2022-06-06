# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :gym_class

  validates :user_id, uniqueness: { scope: :gym_class_id }
  validate :user_is_student

  def user_is_student
    return if User.find(user_id).role.name == 'aluno'

    errors.add(:user_id, 'User is not a student')
  end
end
