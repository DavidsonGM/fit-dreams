# frozen_string_literal: true

FactoryBot.define do
  sequence :user_mail do |n|
    "user#{n}@email.com"
  end

  factory :user do
    name { 'Usuário de fábrica' }
    email { generate(:user_mail) }
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
