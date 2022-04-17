class UnderwritersController < ApplicationController
  before_filter :login_marshall

  def edit
      @underwriter = Underwriter.find(params[:id])
  end

  def update
    @underwriter = Underwriter.find(params[:id])

    respond_to do |format|
      if @underwriter.update_attributes(params[:underwriter])
        format.html { redirect_to '/welcome', notice: 'Underwriter was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @underwriter.errors, status: :unprocessable_entity }
      end
    end
  end

  def new

  end
end
