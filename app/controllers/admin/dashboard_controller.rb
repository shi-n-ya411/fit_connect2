class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    @user_count = User.count
    @post_count = Post.count
  end
end
