# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  protected
  def not_memory_owner_access_denied
    @memory = Memory.find_by_id(params[:id])
    if current_user.id != @memory.user_id
      flash[:error] = "アクセス権限がないページは閲覧できません。"
      redirect_to :controller => 'memories', :action => 'index'
    end
  end

end
