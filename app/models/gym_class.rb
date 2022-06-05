# frozen_string_literal: true

class GymClass < ApplicationRecord
  belongs_to :teacher, class_name: 'User', inverse_of: :teacher_classes
  has_many :lessons, dependent: :destroy
  has_many :students, through: :lessons, source: :user
end
