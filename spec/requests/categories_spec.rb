# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:student) { create(:user) }
  let(:teacher) { create(:teacher) }

  describe 'POST /create' do
    let(:create_category_params) do
      {
        category: { name: 'Categoria teste', description: 'Categoria apenas para fins de testagem' }
      }
    end

    context 'with valid params' do
      before do
        post '/categories/create', params: create_category_params, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the created category data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id name description])
      end

      it 'creates a new category' do
        category = Category.last
        expect(category.name).to eq(create_category_params[:category][:name])
      end
    end

    context 'with invalid params' do
      before do
        Category.delete_all
        create_category_params[:category][:name] = nil
        post '/categories/create', params: create_category_params, headers: {
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

      it 'does not create category' do
        category = Category.last
        expect(category).to be(nil)
      end
    end

    context 'with student token in header' do
      before do
        post '/categories/create', params: create_category_params, headers: {
          'X-User-Email': student.email,
          'X-User-Token': student.authentication_token
        }
      end

      it 'returns a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not create a new category' do
        category = Category.last
        expect(category).to be(nil)
      end
    end

    context 'without user token in header' do
      before { post '/categories/create', params: create_category_params }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new category' do
        category = Category.last
        expect(category).to be(nil)
      end
    end
  end

  describe 'PATCH /update' do
    let(:category) { create(:category) }
    let(:update_category_params) { { category: { name: 'Categoria alterada' } } }

    context 'with valid params' do
      before do
        patch "/categories/update/#{category.id}", params: update_category_params, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated category data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id name description])
      end

      it 'updates category' do
        category.reload
        expect(category.name).to eq(update_category_params[:category][:name])
      end
    end

    context 'with invalid params' do
      before do
        update_category_params[:category][:name] = ''
        patch "/categories/update/#{category.id}", params: update_category_params, headers: {
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

      it 'does not updates category' do
        expect(category.name).not_to eq(update_category_params[:category][:name])
      end
    end

    context 'with student token in header' do
      before do
        patch "/categories/update/#{category.id}", params: update_category_params, headers: {
          'X-User-Email': student.email,
          'X-User-Token': student.authentication_token
        }
      end

      it 'returns a forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not updates category' do
        expect(category.name).not_to eq(update_category_params[:category][:name])
      end
    end

    context 'without teacher token in header' do
      before { patch "/categories/update/#{category.id}", params: update_category_params }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not update category' do
        expect(category.name).not_to eq(update_category_params[:category][:name])
      end
    end
  end

  describe 'GET /show' do
    let(:category) { create(:category) }

    context 'when searching category by id' do
      before { get "/categories/show/#{category.id}" }

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns category data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id name description])
      end
    end

    context 'when searching category by name' do
      before { get '/categories/show', params: { name: category.name } }

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns category data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id name description])
      end
    end

    context 'when both name and id params are passed' do
      let(:category2) { create(:category, name: 'Categoria teste 2') }

      before { get "/categories/show/#{category.id}", params: { email: category2.name } }

      it 'searches category by id' do
        expect(JSON.parse(response.body)['name']).to eq(category.name)
      end

      it 'does not search category by name' do
        expect(JSON.parse(response.body)['name']).not_to eq(category2.name)
      end
    end

    context 'when category cant be found' do
      before do
        category.destroy
        get "/categories/show/#{category.id}"
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
    let(:category) { create(:category) }

    context 'when category is properly deleted' do
      before do
        delete "/categories/delete/#{category.id}", headers: {
          'X-User-Email': teacher.email, 'X-User-Token': teacher.authentication_token
        }
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the category' do
        expect(Category.find_by(id: category.id)).to be(nil)
      end
    end

    context 'without user authentication info' do
      before { delete "/categories/delete/#{category.id}" }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not delete category' do
        expect(Category.find_by(id: category.id)).not_to be(nil)
      end
    end

    context 'with student authentication info' do
      before do
        delete "/categories/delete/#{category.id}", headers: {
          'X-User-Email': student.email,
          'X-User-Token': student.authentication_token
        }
      end

      it 'returns an forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not delete category' do
        expect(Category.find_by(id: category.id)).not_to be(nil)
      end
    end
  end

  describe 'GET /index' do
    before do
      create(:category, name: 'Categoria 1')
      create(:category, name: 'Categoria 2')
      get '/categories/index'
    end

    it 'returns an ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all categories in an array' do
      expect(JSON.parse(response.body).size).to eq(Category.count)
    end

    it 'returns category info in the array elements' do
      expect(JSON.parse(response.body).first.keys).to eq(%w[id name description])
    end
  end
end
