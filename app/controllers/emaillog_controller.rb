class EmaillogController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :emailloghome, :sidenav, :only => %w(view)

  def emaillog
  end
end