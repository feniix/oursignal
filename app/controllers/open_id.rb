class OpenId < Merb::Controller
  before :ensure_openid_url

  def signup
    # TODO: Thats one ugly interface.
    # TODO: The openid basic strategy needs work. It doesn't pass openid.fullname via the session like it should.
    user = Merb::Authentication.user_class.find_or_create_by_openid(
      {:'openid.identifier' => session['openid.url']},
      {
        :openid   => {:identifier => session['openid.url']},
        :email    => session['openid.email'],
        :fullname => session['openid.fullname'],
        :username => session['openid.nickname']
      }
    )

    if user
      session.user = user
      redirect url(:user, session.user.id), :message => {:notice => 'Signup was successful'}
    else
      message[:error] = 'There was an error while creating your user account'
      redirect(url(:openid))
    end
  end

  private
    def ensure_openid_url
      throw :halt, redirect(url(:openid)) if session['openid.url'].nil?
    end
end
