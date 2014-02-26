class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def require_admin
    unless current_user.is_superuser
      flash[:error] = 'Only admin has access to this page.'
      redirect_to :root
    end
  end

  def require_normal_user
    if current_user.is_superuser
      flash[:error] = 'Only normal users have access to this page.'
      redirect_to :root
    end
  end

end
