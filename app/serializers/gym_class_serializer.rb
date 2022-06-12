# frozen_string_literal: true

class GymClassSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :duration, :description

  belongs_to :teacher
  belongs_to :category
end
