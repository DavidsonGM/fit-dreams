# frozen_string_literal: true

class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[update delete sign_up login], fallback_to_devise: false
  before_action :require_login, only: %i[update delete]
  before_action :require_not_logged, only: %i[sign_up login]

  def sign_up
    user = User.create!(create_user_params)
    render json: user, status: :created
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def login
    user = User.find_by!(email: params[:email])
    if user.valid_password?(params[:password])
      render json: user.to_json(only: %i[email authentication_token]), status: :ok
    else
      render json: { error: 'Usuário ou senha inválidos!' }, status: :unauthorized
    end
  rescue StandardError
    render json: { error: 'Não existe uma conta associada a esse email!' }, status: :not_found
  end

  def show
    user = if params[:id]
             User.find(params[:id])
           else
             User.find_by!(email: params[:email])
           end
    render json: user, include: %w[role student_classes.category teacher_classes.category], status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :not_found
  end

  def update
    user = current_user
    user.update!(update_user_params)
    render json: user, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def delete
    user = current_user
    user.destroy!
    render json: { message: "Usuário #{user.name} deletado com sucesso" }, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  # def student_index
  #   users = User.where(role: Role.find_by!(name: 'aluno'))
  #   render json: users, status: :ok
  # end

  private

  def create_user_params
    params.require(:user).permit(:name, :birthdate, :email, :password, :password_confirmation, :role_id)
  end

  def update_user_params
    params.require(:user).permit(:name, :birthdate, :role_id)
  end

  def require_not_logged
    head(:bad_request) if current_user
  end
end
