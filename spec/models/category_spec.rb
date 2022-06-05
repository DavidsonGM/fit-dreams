# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'factory' do
    context 'when using default factory' do
      it { expect(build(:category)).to be_valid }
    end
  end

  describe 'validations' do
    context 'when name is blank' do
      it { expect(build(:category, name: '')).not_to be_valid }
    end

    context 'when name already exist' do
      before { create(:category) }

      it { expect(build(:category)).not_to be_valid }
    end

    context 'when description is blank' do
      it { expect(build(:category, description: '')).not_to be_valid }
    end

    context 'when description is too small' do
      it { expect(build(:category, description: 'aula boa')).not_to be_valid }
    end
  end
end
