class ApplicationController < ActionController::Base
  include SimplestAuth::Controller

  helper :all
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_event

  def login_message
    'Tsk. tsk. tsk. Stop being naughty.'
  end

  def access_denied
    flash[:notice] = login_message
    redirect_to participants_path
  end

  def current_event
    Event.current
  end
end
