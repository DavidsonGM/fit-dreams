class GymClassesController < ApplicationController
  acts_as_token_authentication_handler_for User, except: %i[show index], fallback_to_devise: false
  before_action :require_admin_or_teacher, except: %i[show index]

  def index
    items_per_page = params[:items_per_page] || 30
    page = params[:page] || 1
    gym_classes = GymClass.limit(items_per_page).offset((page - 1) * items_per_page)
    render json: gym_classes, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def show
    gym_class = GymClass.find(params[:id])
    render json: gym_class, status: :ok
  rescue StandardError
    render json: { error: 'Turma não encontrada' }, status: :not_found
  end

  def create
    gym_class = GymClass.new(gym_class_params)
    gym_class.save!
    render json: gym_class, status: :created
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def update
    gym_class = GymClass.find(params[:id])
    gym_class.update!(gym_class_params)
    render json: gym_class, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def delete
    gym_class = GymClass.find(params[:id])
    gym_class.destroy!
    render json: { message: "Turma de #{gym_class.name} deletada com sucesso!" }, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  private

  def gym_class_params
    params.require(:gym_class).permit(:name, :description, :start_time, :duration, :teacher_id, :category_id)
  end
end
