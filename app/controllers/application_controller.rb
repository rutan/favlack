class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def page
    (params[:page] || 1).to_i
  end

  def sort_type
    case params[:filter]
    when 'popular'
      :popular
    else
      :new
    end
  end
end
