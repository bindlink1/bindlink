class DocumentpagesController < ApplicationController

  before_filter :login_marshall

  def showpages
    @documentpages = Documentpage.find_all_by_document_id(params[:id], :order=>'page_number ASC')

  end
end
