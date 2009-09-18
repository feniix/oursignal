class Exceptions < Merb::Controller
  provides :json

  def bad_request
    display messages
  end

  def not_found
    display messages
  end

  def not_acceptable
    display messages
  end

  def unauthenticated
    cookies.delete(:username) if !session.user
    display messages
  end

  private
    def messages
      request.exceptions.map(&:message)
    end
end
