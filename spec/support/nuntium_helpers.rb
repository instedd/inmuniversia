module NuntiumHelpers

  def hhtp_authorization request, username, password
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{username}:#{password}")
  end

end