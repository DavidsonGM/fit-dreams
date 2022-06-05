# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :name, presence: true, uniqueness: true, inclusion: { in: %w[aluno professor admin] }
end
