class MessageTemplatesController < ApplicationController
  layout 'applicationfunctional'
  before_filter :login_marshall
  set_tab :templateshome, :sidenav, :only => %w(view)

  def index
    @templates = MessageTemplate.all()

  	respond_to do |format|
      format.html
    end
  end

  def new
    @template = MessageTemplate.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @template = MessageTemplate.new(params[:message_template])

    respond_to do |format|
      if @template.save
        @templates = MessageTemplate.all()
        format.js
      end
    end
  end

  def edit
    @template = MessageTemplate.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @template  = MessageTemplate.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:message_template])
        @templates = MessageTemplate.all()
        format.js
      end

    end
  end

  def destroy
    @template = MessageTemplate.find(params[:id])

    @result = "#{@template.name} is deleted"
    @direct = "redirect"
    @template.destroy

    respond_to do |format|
      @templates = MessageTemplate.all()
      format.js
    end
  end
end