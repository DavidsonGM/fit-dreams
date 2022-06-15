# frozen_string_literal: true

class LessonsController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_action :require_login
  before_action :authenticate_current_user

  def create
    lesson = Lesson.new(lesson_params)
    lesson.save!
    render json: { message: "Aluno #{lesson.user.name} matriculado na aula de #{lesson.gym_class.name}" }, status: :created
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def delete
    lesson = Lesson.find_by!(user_id: params[:user_id], gym_class_id: params[:gym_class_id])
    lesson.destroy!
    render json: { message: "Aluno #{lesson.user.name} desmatriculado da aula de #{lesson.gym_class.name}" }, status: :created
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  private

  def lesson_params
    params.require(:lesson).permit(:user_id, :gym_class_id)
  end
  
  def authenticate_current_user
    require_admin_or_teacher if current_user.id != params[:user_id]
  end
end
