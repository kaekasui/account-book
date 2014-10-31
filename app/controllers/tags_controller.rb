class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy, :set_color_code_text_field, :set_name_text_field]
  respond_to :js

  def index
    @tag = current_user.tags.new
    @tags = current_user.tags.all
  end

  def show
    respond_with(@tag)
  end

  def create
    @tag = current_user.tags.new(tag_params)
    respond_to do |format|
      if @tag.save
        format.js
      else
        format.js { render file: "tags/failure_create" }
      end
    end
  end

  def update
    @tag.update_attributes(tag_params)
    @color_code = tag_params[:color_code] if tag_params[:color_code]
    @name = tag_params[:name] if tag_params[:name]
    respond_to do |format|
      if @tag.save
        format.js
      else
        format.js { render file: "tags/failure_update" }
      end
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path
  end

  def set_color_code_text_field
  end

  def set_name_text_field
  end

  private
    def set_tag
      @tag = current_user.tags.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name, :color_code)
    end
end
