# frozen_string_literal: true

class CategoriesController < ApplicationController
  acts_as_token_authentication_handler_for User, except: %i[show index], fallback_to_devise: false
  before_action :require_admin_or_teacher, except: %i[show index]

  def index
    categories = Category.all
    render json: categories, status: :ok
  end

  def show
    category = if params[:id]
                 Category.find(params[:id])
               else
                 Category.find_by!(name: params[:name])
               end
    render json: category, status: :ok
  rescue StandardError
    render json: { error: 'Categoria não encontrada' }, status: :not_found
  end

  def create
    category = Category.new(category_params)
    category.save!
    render json: category, status: :created
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def update
    category = Category.find(params[:id])
    category.update!(category_params)
    render json: category, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  def delete
    category = Category.find(params[:id])
    category.destroy!
    render json: { message: "Categoria #{category.name} deletada com sucesso!" }, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
