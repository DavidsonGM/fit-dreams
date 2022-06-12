# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /sign_up' do
    let(:role) { create(:role) }
    let(:create_user_params) do
      {
        user: {
          name: 'Nome teste', birthdate: '2001-10-02', email: 'email@teste.com',
          password: '123456', password_confirmation: '123456', role_id: role.id
        }
      }
    end

    context 'with valid params' do
      before { post '/users/sign_up', params: create_user_params }

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the created user data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id email name birthdate role])
      end

      it 'creates a new user' do
        user = User.last
        expect(user.email).to eq(create_user_params[:user][:email])
      end
    end

    context 'with invalid params' do
      before do
        User.delete_all
        create_user_params[:user][:email] = 'teste'
        post '/users/sign_up', params: create_user_params
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error in response' do
        expect(JSON.parse(response.body).keys).to eq(%w[error])
      end

      it 'does not create user' do
        user = User.last
        expect(user).to be(nil)
      end
    end

    context 'with user token in header' do
      let(:user) { create(:user, role_id: role.id) }

      before do
        post '/users/sign_up', params: create_user_params, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create a new user' do
        last_user = User.last
        expect(last_user.email).to eq(user.email)
      end
    end
  end

  describe 'PATCH /update' do
    let(:user) { create(:user) }
    # before { create(:user, name: 'Nome teste') }

    let(:update_user_params) { { user: { name: 'Nome alterado' } } }

    context 'with valid params' do
      before do
        patch '/users/update', params: update_user_params, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated user data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id email name birthdate role])
      end

      it 'updates user' do
        user.reload
        expect(user.name).to eq(update_user_params[:user][:name])
      end
    end

    context 'with invalid params' do
      before do
        update_user_params[:user][:name] = ''
        patch '/users/update', params: update_user_params, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error in response' do
        expect(JSON.parse(response.body).keys).to eq(%w[error])
      end

      it 'does not updates user' do
        expect(user.name).not_to eq(update_user_params[:user][:name])
      end
    end

    context 'without user token in header' do
      before { patch '/users/update', params: update_user_params }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not update user' do
        expect(user.name).not_to eq(update_user_params[:user][:name])
      end
    end
  end

  describe 'POST /login' do
    let(:user) { create(:user, password: 'SenhaTeste', password_confirmation: 'SenhaTeste') }
    let(:login_params) { { email: user.email, password: 'SenhaTeste' } }

    context 'with valid user info' do
      before { post '/users/sign_in', params: login_params }

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns user authentication info' do
        expect(JSON.parse(response.body).keys).to eq(%w[email authentication_token])
      end
    end

    context 'when user email does not exist' do
      before do
        login_params[:email] = 'no_user@mail.com'
        post '/users/sign_in', params: login_params
      end

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body).keys).to eq(['error'])
      end
    end

    context 'when user password is wrong' do
      before do
        login_params[:password] = 'wrong password'
        post '/users/sign_in', params: login_params
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body).keys).to eq(['error'])
      end
    end

    context 'when user is already logged in' do
      before do
        post '/users/sign_in', params: login_params, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }

    context 'when searching user by id' do
      before { get "/users/show/#{user.id}" }

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns user data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id email name birthdate role])
      end
    end

    context 'when searching user by email' do
      before { get '/users/show', params: { email: user.email } }

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns user data' do
        expect(JSON.parse(response.body).keys).to eq(%w[id email name birthdate role])
      end
    end

    context 'when both email and id params are passed' do
      let(:user2) { create(:user, role: user.role) }

      before { get "/users/show/#{user.id}", params: { email: user2.email } }

      it 'searches user by id' do
        expect(JSON.parse(response.body)['email']).to eq(user.email)
      end

      it 'does not search user by email' do
        expect(JSON.parse(response.body)['email']).not_to eq(user2.email)
      end
    end

    context 'when user cant be found' do
      before do
        user.destroy
        get "/users/show/#{user.id}"
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
    let(:user) { create(:user) }

    context 'when user is properly deleted' do
      before do
        delete '/users/delete', headers: {
          'X-User-Email': user.email, 'X-User-Token': user.authentication_token
        }
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the user' do
        expect(User.find_by(id: user.id)).to be(nil)
      end
    end

    context 'without user authentication info' do
      before { delete '/users/delete' }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not delete user' do
        expect(User.find_by(id: user.id)).not_to be(nil)
      end
    end
  end
end
