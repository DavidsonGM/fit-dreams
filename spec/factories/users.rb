# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Usuário de fábrica' }
    email { 'user@email.com'}
    password { 'Senha123' }
    password_confirmation { 'Senha123' }
    birthdate { '2001-10-02' }
    role { create(:role, name: 'aluno') }

    factory :teacher do
      role { create(:role, name: 'professor') }
    end

    factory :admin do
      role { create(:role, name: 'admin') }
    end
  end
end
