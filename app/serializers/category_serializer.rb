# frozen_string_literal: true

class CategorySerializer < ActiveModel::Serializer
  attributes :name, :description
end
