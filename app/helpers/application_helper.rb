module ApplicationHelper
  def nav_active_class(path)
    if request.path == path
      "active"
    else
      ""
    end
  end
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  def current_user= (user)
    @current_user = user
  end
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  def current_user?(user)
    user == current_user
  end
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to root_path, notice: "Please sign in."
    end
  end

  def authorize?(user)
    current_user.admin || user==current_user 
  end
  def authorize_check(user)
    unless authorize?(user)
      flash[:error]="only authorize can access"
      redirect_to root_url
     end
  end
  def signed_in?
    !current_user.nil?
  end
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
