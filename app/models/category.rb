# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :gym_classes, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
end
