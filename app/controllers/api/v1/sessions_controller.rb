class Api::V1::SessionsController < ApplicationController
  # TODO add jwt_token field to user
  # add sign up
  def sign_in
    user = User.find_by(phone_number: params[:phone_number])
    if  user&.verified
      render json:  UserSerializer.new(user), status: :ok
    else
      render json: {msg: "Name or password is incorrect"}, status: :unauthorized
    end
  end
end
