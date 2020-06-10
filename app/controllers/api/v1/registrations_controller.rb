class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_params_exist, only: :create

  def create
    user = User.new(user_params)
    if user.save
      json_response('Signed Succesfully', true, { user: user }, :ok)
    else
      json_response('Something Wrong', false , {}, :unprocessable_entity)
    end
  end


  private

  def ensure_params_exist
    return  if params[:user].present?
    json_response('Missing Params', false , {}, :bad_request)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end