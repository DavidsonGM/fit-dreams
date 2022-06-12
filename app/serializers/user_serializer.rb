# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :birthdate

  belongs_to :role
  has_many :student_classes, if: -> { object.role.name == 'aluno' }
  has_many :teacher_classes, if: -> { object.role.name == 'professor' }
end
