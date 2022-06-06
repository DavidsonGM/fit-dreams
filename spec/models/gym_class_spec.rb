# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GymClass, type: :model do
  describe 'factory' do
    context 'when using default factory' do
      it { expect(build(:gym_class)).to be_valid }
    end
  end

  describe 'validations' do
    context 'when some field is blank' do
      it { expect(build(:gym_class, name: '')).not_to be_valid }

      it { expect(build(:gym_class, start_time: '')).not_to be_valid }

      it { expect(build(:gym_class, duration: nil)).not_to be_valid }

      it { expect(build(:gym_class, description: '')).not_to be_valid }
    end

    context 'when duration is not a number' do
      it { expect(build(:gym_class, duration: '1')).not_to be_valid }
    end

    context 'when duration is negative' do
        it { expect(build(:gym_class, duration: -1)).not_to be_valid }
    end

    context 'when duration is too short' do
      it { expect(build(:gym_class, duration: 4)).not_to be_valid }
    end

    context 'when start time is before current date' do
      it { expect(build(:gym_class, start_time: Time.zone.now.yesterday)).not_to be_valid }
    end

    context 'when teacher_id does not belong to a teacher' do
      let(:aluno) { create(:user) }

      it { expect(build(:gym_class, teacher_id: aluno.id)).not_to be_valid }
    end

  end
end
