# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  context 'with default factory' do
    it { expect(build(:role)).to be_valid }
  end

  describe 'validations' do
    context 'when name is valid' do
      it { expect(build(:role, name: 'professor')).to be_valid }
      it { expect(build(:role, name: 'admin')).to be_valid }
      it { expect(build(:role, name: 'aluno')).to be_valid }
    end

    context 'when name is blank' do
      it { expect(build(:role, name: '')).not_to be_valid }
    end

    context 'when name already exist' do
      before { create(:role, name: 'professor') }

      it { expect(build(:role, name: 'professor')).not_to be_valid }
    end

    context 'when name is not valid' do
      it { expect(build(:role, name: 'teacher')).not_to be_valid }
    end
  end
end
