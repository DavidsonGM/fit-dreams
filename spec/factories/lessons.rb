# frozen_string_literal: true

FactoryBot.define do
  factory :lesson do
    user { create(:user) }
    gym_class { create(:gym_class) }
  end
end
