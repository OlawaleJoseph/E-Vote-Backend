module AuthHelper
  def json
    JSON.parse(response.body)
  end

  def login_user(user)
    post '/api/v1/auth/login', params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
    response.headers['Authorization']
  end

  def headers(token)
    { 'Accept': 'application/json', 'Authorization': token }
  end
end
