# Top page.
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @messages = current_user.messages.all
    @notices = Notice.all
  end
end
