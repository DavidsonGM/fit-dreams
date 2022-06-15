# frozen_string_literal: true

class ApplicationController < ActionController::API
  def require_login
    head(:unauthorized) unless current_user.presence
  end

  def require_admin_or_teacher
    if current_user.presence
      head(:forbidden) if current_user.role.name == 'aluno'
    else
      head(:unauthorized)
    end
  end
end
