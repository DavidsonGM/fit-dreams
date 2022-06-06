# frozen_string_literal: true

FactoryBot.define do
  factory :gym_class do
    name { 'Abdominais' }
    start_time { Time.zone.now.tomorrow }
    duration { 50 }
    description { 'Aula focada em exercícios que trabalham músculos da região do abdomen' }
    category { create(:category) }
    teacher { create(:teacher) }
  end
end
