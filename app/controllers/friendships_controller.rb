class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.unconfirm_friendships.build(friend_id: params[:friend_id])

    if @friendship.save
      flash[:notice] = "Friend request successfully sent!" 
      redirect_back fallback_location: root_path, notice: "申請好友成功"
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end 
  end

  def destroy
    if current_user.friendships.empty? && current_user.inverse_friendships.empty?
      if !current_user.unconfirm_friendships.empty?
        @friendship = current_user.unconfirm_friendships.where(friend_id: params[:id]).first
      end
    else
      if current_user.friendships.empty?
        @friendship = current_user.inverse_friendships.where(user_id: params[:id]).first
      else
        @friendship = current_user.friendships.where(friend_id: params[:id]).first
      end
    end
    @friendship.destroy
    redirect_back(fallback_location: root_path)
  end

  def confirm
    @friendship = current_user.request_friendships.where(user_id: params[:format]).first
    @friendship.update(status: true)

    redirect_back fallback_location: root_path
  end

  def reject
    @friendship = current_user.request_friendships.where(user_id: params[:format]).first
    @friendship.destroy

    redirect_back fallback_location: root_path
   end

end
