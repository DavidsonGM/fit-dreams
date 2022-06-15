# frozen_string_literal: true

class GymClassSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :start_time, :duration

  belongs_to :category
  belongs_to :teacher
  has_many :students
end
