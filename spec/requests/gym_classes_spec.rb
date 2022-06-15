# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GymClasses', type: :request do
  let(:student) { create(:user) }
  let(:teacher) { create(:teacher) }

  describe 'POST /create' do
    let(:category) { create(:category) }

    let(:create_gym_class_params) do
      {
        gym_class: {
          name: 'Aula teste', description: 'Aula apenas para fins de testagem', teacher_id: teacher.id,
          category_id: category.id, duration: 10, start_time: '20-03-2023 20:40:00'
        }
      }
    end

    context 'with valid params' do
      before do
        post '/gym_classes/create', params: create_gym_class_params, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the created gym class data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id name description start_time duration category teacher students])
      end

      it 'creates a new gym class' do
        gym_class = GymClass.last
        expect(gym_class.name).to eq(create_gym_class_params[:gym_class][:name])
      end
    end

    context 'with invalid params' do
      before do
        GymClass.delete_all
        create_gym_class_params[:gym_class][:name] = nil
        post '/gym_classes/create', params: create_gym_class_params, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error in response' do
        expect(JSON.parse(response.body).keys).to eq(%w[error])
      end

      it 'does not create gym_class' do
        gym_class = GymClass.last
        expect(gym_class).to be(nil)
      end
    end

    context 'with student token in header' do
      before do
        post '/gym_classes/create', params: create_gym_class_params, headers: {
          'X-User-Email': student.email,
          'X-User-Token': student.authentication_token
        }
      end

      it 'returns a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not create a new gym class' do
        gym_class = GymClass.last
        expect(gym_class).to be(nil)
      end
    end

    context 'without user token in header' do
      before { post '/gym_classes/create', params: create_gym_class_params }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new gym_class' do
        gym_class = GymClass.last
        expect(gym_class).to be(nil)
      end
    end
  end

  describe 'PATCH /update' do
    let(:gym_class) { create(:gym_class, teacher_id: teacher.id) }
    let(:update_gym_class_params) { { gym_class: { name: 'Aula alterada' } } }

    context 'with valid params' do
      before do
        patch "/gym_classes/update/#{gym_class.id}", params: update_gym_class_params, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated gym_class data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id name description start_time duration category teacher students])
      end

      it 'updates gym_class' do
        gym_class.reload
        expect(gym_class.name).to eq(update_gym_class_params[:gym_class][:name])
      end
    end

    context 'with invalid params' do
      before do
        update_gym_class_params[:gym_class][:name] = ''
        patch "/gym_classes/update/#{gym_class.id}", params: update_gym_class_params, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error in response' do
        expect(JSON.parse(response.body).keys).to eq(%w[error])
      end

      it 'does not updates gym_class' do
        expect(gym_class.name).not_to eq(update_gym_class_params[:gym_class][:name])
      end
    end

    context 'with student token in header' do
      before do
        patch "/gym_classes/update/#{gym_class.id}", params: update_gym_class_params, headers: {
          'X-User-Email': student.email,
          'X-User-Token': student.authentication_token
        }
      end

      it 'returns a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not updates gym_class' do
        expect(gym_class.name).not_to eq(update_gym_class_params[:gym_class][:name])
      end
    end

    context 'without teacher token in header' do
      before { patch "/gym_classes/update/#{gym_class.id}", params: update_gym_class_params }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not update gym_class' do
        expect(gym_class.name).not_to eq(update_gym_class_params[:gym_class][:name])
      end
    end
  end

  describe 'GET /show' do
    let(:gym_class) { create(:gym_class) }

    context 'when searching gym class by id' do
      before { get "/gym_classes/show/#{gym_class.id}" }

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns gym_class data' do
        expect(JSON.parse(response.body).keys).to eq(
          %w[id name description start_time duration category teacher students]
        )
      end
    end

    context 'when gym_class cant be found' do
      before do
        gym_class.destroy
        get "/gym_classes/show/#{gym_class.id}"
      end

      it 'returns a not found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error in response' do
        expect(JSON.parse(response.body).keys).to eq(['error'])
      end
    end
  end

  describe 'DELETE /delete' do
    let(:gym_class) { create(:gym_class, teacher_id: teacher.id) }

    context 'when gym_class is properly deleted' do
      before do
        delete "/gym_classes/delete/#{gym_class.id}", headers: {
          'X-User-Email': teacher.email, 'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the gym class' do
        expect(GymClass.find_by(id: gym_class.id)).to be(nil)
      end
    end

    context 'without user authentication info' do
      before { delete "/gym_classes/delete/#{gym_class.id}" }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not delete gym class' do
        expect(GymClass.find_by(id: gym_class.id)).not_to be(nil)
      end
    end

    context 'with student authentication info' do
      before do
        delete "/gym_classes/delete/#{gym_class.id}", headers: {
          'X-User-Email': student.email,
          'X-User-Token': student.authentication_token
        }
      end

      it 'returns an forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not delete gym_class' do
        expect(GymClass.find_by(id: gym_class.id)).not_to be(nil)
      end
    end
  end

  describe 'GET /index' do
    before do
      category = create(:category)
      (1..50).each do |i|
        create(:gym_class, name: "Aula #{i}", category_id: category.id, teacher_id: teacher.id)
      end
    end

    context 'without pagination params' do
      before { get '/gym_classes/index' }

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a maximum of 30 classes in an array' do
        expect(JSON.parse(response.body).size).to eq(GymClass.limit(30).count)
      end

      it 'returns gym_class info in the array elements' do
        expect(JSON.parse(response.body).first.keys).to eq(%w[id name description start_time duration category teacher students])
      end
    end

    context 'with correct pagination params' do
      let(:pagination_params) { { items_per_page: 7, page: 2 } }

      before { get '/gym_classes/index', params: pagination_params }

      it 'returns the number of elements specified in items_per_page param' do
        expect(JSON.parse(response.body).size).to eq(pagination_params[:items_per_page])
      end

      it 'has an offset depending on the params (or default values)' do
        offset = (pagination_params[:page] - 1) * pagination_params[:items_per_page]
        expect(JSON.parse(response.body).first['id']).to eq(GymClass.all.offset(offset).first.id)
      end
    end

    context 'with incorrect pagination params' do
      let(:pagination_params) { { items_per_page: -2, page: -1 } }

      before { get '/gym_classes/index', params: pagination_params }

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error in response' do
        expect(JSON.parse(response.body).keys).to eq(['error'])
      end
    end
  end
end
