class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    # You need to implement the method(from_omniauth) below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    
    if @user.persisted?
      # 如果User存在

      #this will throw if @user is not activated
      sign_in_and_redirect @user, event: :authentication  

      # 出現Flash提示訊息
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?

    else
      # 如果User不存在

      # 就把FB回傳的資料丟進Devise的註冊方法，在本地端建立一個新的User
      session["devise.facebook_data"] = request.env["omniauth.auth"]

      redirect_to new_user_registration_url
      
    end
  end

  def failure
    redirect_to root_path
  end
end