class AnnouncementsController < ApplicationController
  protect_from_forgery

  def hide
    ids = [params[:id], *cookies.signed[:hidden_announcement_ids]]
    cookies.permanent.signed[:hidden_announcement_ids] = ids


    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

end
