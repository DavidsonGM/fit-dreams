# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :gym_class
end
