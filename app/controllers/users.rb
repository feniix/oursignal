require 'recaptcha'

class Users < Application
  before :ensure_authenticated, :exclude => [:show, :new, :create]
  before :ensure_authorized,    :exclude => [:show, :new, :create, :login]
  after  :purge_user_feed,      :exclude => [:create, :login]

  def show
    provides :rss, :xml, :json
    http_max_age 5.minutes
    display @links = user.links
  end

  def new
    display @user = User.new
  end

  def create
    # TODO: This could be part of validations on User.new.new?
    @captcha = Recaptcha.new('6Lc1hwcAAAAAADJWrrR3EeMFrI-NLYbw7x7F1S0w').verify(
      request.remote_ip,
      params[:recaptcha_challenge_field],
      params[:recaptcha_response_field]
    )

    @user = User.new(params[:user])
    if @user.save && @captcha.success
      session.user = @user
      redirect url(:users, @user.username, :action => :edit)
    else
      render :new, :status => 422, :message => {:error => 'There was an error creating your user account'}
    end
  end

  def edit
    @user = session.user
    raise NotFound unless @user
    display @user
  end

  def update
    @user = session.user
    raise NotFound unless @user

    # TODO: Must be a nicer way to do these.
    params[:user][:theme] = Theme.get(params[:user][:theme]) unless params[:user][:theme].blank?

    if @user.update(params[:user])
      redirect url(:users, @user.username), :message => {:notice => 'Your user account was updated'}
    else
      display @user, :edit, :status => 422, :message => {:error => 'There was an error updating your user account'}
    end
  end

  def login
    if session.user
      cookies[:username] = user.username
      redirect url(:users, user.username, :action => :edit)
    end
  end

  def logout
    session.abandon!
    cookies.delete(:username)
    redirect '/', :message => {:notice => 'You are now logged out'}
  end
end
