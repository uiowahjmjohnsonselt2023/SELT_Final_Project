class FAQController < ApplicationController
  before_action :set_current_user


  def show
    # @item is already set by set_item
    @user = current_user
    @item
    @seller = User.find(@item.user_id)
  end

end
