# Top page.
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @messages = current_user ? current_user.messages.all.order(:created_at).reverse_order.limit(5) : {}
    @notices = Notice.all
  end
end
