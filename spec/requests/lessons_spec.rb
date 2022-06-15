# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lessons', type: :request do
  let(:admin) { create(:admin) }
  let(:student1) { create(:user) }
  let(:student2) { create(:user, role: student1.role) }
  let(:gym_class) { create(:gym_class) }

  describe 'POST /create' do
    let(:create_lesson_params) { { lesson: { user_id: student1.id, gym_class_id: gym_class.id } } }

    context 'when admin register user in class' do
      before do
        post '/lessons/create', params: create_lesson_params, headers: {
          'X-User-Email': admin.email,
          'X-User-Token': admin.authentication_token
        }
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a new lesson for student' do
        lesson = Lesson.find_by(user_id: student1.id, gym_class_id: gym_class.id)
        expect(lesson).not_to be(nil)
      end
    end

    context 'when class/user does not exist' do
      before do
        gym_class.destroy
        post '/lessons/create', params: create_lesson_params, headers: {
          'X-User-Email': admin.email,
          'X-User-Token': admin.authentication_token
        }
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create a new lesson for student' do
        lesson = Lesson.find_by(user_id: student1.id, gym_class_id: gym_class.id)
        expect(lesson).to be(nil)
      end
    end

    context 'when user wants to register himself in class' do
      before do
        post '/lessons/create', params: create_lesson_params, headers: {
          'X-User-Email': student1.email,
          'X-User-Token': student1.authentication_token
        }
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a new lesson for student' do
        lesson = Lesson.find_by(user_id: student1.id, gym_class_id: gym_class.id)
        expect(lesson).not_to be(nil)
      end
    end

    context 'when student wants to register another student in class' do
      before do
        create_lesson_params[:lesson][:user_id] = student2.id
        post '/lessons/create', params: create_lesson_params, headers: {
          'X-User-Email': student1.email,
          'X-User-Token': student1.authentication_token
        }
      end

      it 'returns a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not create a new lesson for student' do
        lesson = Lesson.find_by(user_id: student2.id, gym_class_id: gym_class.id)
        expect(lesson).to be(nil)
      end
    end

    context 'without user header' do
      before do
        post '/lessons/create', params: create_lesson_params
      end

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new lesson for student' do
        lesson = Lesson.find_by(user_id: student1.id, gym_class_id: gym_class.id)
        expect(lesson).to be(nil)
      end
    end
  end
end
