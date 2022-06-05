# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    context 'when using default user factory' do
      it { expect(build(:user)).to be_valid }

      it { expect(build(:user).role.name).to eq 'aluno' }
    end

    context 'when using teacher factory' do
      it { expect(build(:teacher)).to be_valid }

      it { expect(build(:teacher).role.name).to eq 'professor' }
    end

    context 'when using admin factory' do
      it { expect(build(:admin)).to be_valid }

      it { expect(build(:admin).role.name).to eq 'admin' }
    end
  end

  describe 'validations' do
    context 'when some field is blank' do
      it { expect(build(:user, name: '')).not_to be_valid }

      it { expect(build(:user, email: '')).not_to be_valid }

      it { expect(build(:user, birthdate: '')).not_to be_valid }

      it { expect(build(:user, role_id: nil)).not_to be_valid }
    end

    context 'when role does not exist' do
      before { Role.delete_all }

      it { expect(build(:user, role_id: 1)).not_to be_valid }
    end

    context 'when email format is not valid' do
      it { expect(build(:user, email: 'email.com')).not_to be_valid }
    end

    context 'when user_mail already exists' do
      let(:user) { create(:user) }

      it { expect(build(:user, role_id: user.role_id)).not_to be_valid }
    end

    context 'when birthdate format is not valid' do
      it { expect(build(:user, birthdate: '2 de janeiro de 2001')).not_to be_valid }
    end

    context 'when birthdate is after current date' do
      it { expect(build(:user, birthdate: Time.zone.now.tomorrow.to_date)).not_to be_valid }
    end
  end
end
