class Al3filesController < ApplicationController
  skip_before_filter :postalfile, :verify_authenticity_token

  def postalfile



    if params[:key] == 'j5uSS5sGsfty446'

      recdate =  Date.strptime(params[:file_received_date], '%m/%d/%Y')

      duplookup = Al3file.where("file_received_date = ? AND file_name = ?",recdate,params[:file_name]).count()

      if duplookup == 0
      newalfile = Al3file.new
      newalfile.agency_id = params[:id]
      newalfile.file_received_date = recdate
      newalfile.file_name = params[:file_name]
      newalfile.processed = false
      newalfile.save

      render :text => 'success'
      else

      render :text => 'duplicate entry!'
      end

    end

  end
end
