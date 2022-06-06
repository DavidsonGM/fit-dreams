# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'factory' do
    context 'when using default factory' do
      it { expect(build(:lesson)).to be_valid }
    end
  end

  describe 'validations' do
    context 'when user is not a student' do
      let(:teacher) { create(:teacher) }
      let(:gym_class) { create(:gym_class, teacher: teacher) }

      it { expect(build(:lesson, gym_class: gym_class, user: teacher)).not_to be_valid }
    end

    context 'when student is already in class' do
      let(:student_class) { create(:lesson) }

      it { expect(build(:lesson, gym_class: student_class.gym_class, user: student_class.user)).not_to be_valid }
    end
  end
end
