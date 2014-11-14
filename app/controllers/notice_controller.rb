# Notice, for example terms.
class NoticeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def terms
  end
end
