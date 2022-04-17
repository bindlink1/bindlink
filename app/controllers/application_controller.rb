class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_cache_buster

  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end


  def login_marshall
    logger.warn "LOGIN ATTEMPT " + request.remote_ip

    if agent_signed_in?
      if !current_agent.is_active
        redirect_to "/"
      elsif current_agent.is_admin
        # allow any IP, do nothing
      else
        # only allow ip from Granada
        if request.remote_ip == '10.0.2.2' or
          request.remote_ip == '109.63.133.141' or
          request.remote_ip == '99.101.145.219' or
          request.remote_ip == '74.231.216.2' or
          request.remote_ip == '50.73.151.105' or
          request.remote_ip == '50.73.151.106' or
          request.remote_ip == '50.73.151.107' or
          request.remote_ip == '50.73.151.108' or
          request.remote_ip == '50.73.151.109' or
          request.remote_ip == '50.205.176.198' or 
          request.remote_ip == '52.202.17.20' or
          request.remote_ip == '205.224.245.96' or #sgsdt 1
          request.remote_ip == '76.108.51.103' or #sgsdt 1.1
          request.remote_ip == '80.76.99.60' #sgsdt 2
        else
          redirect_to "/"
        end
      end
    elsif underwriter_signed_in?

    elsif admin_signed_in?

    else
      redirect_to "/"
      logger.warn "UNAUTHORIZED LOGIN ATTEMPT"
    end
  end


  def permission_marshall(id)
    if current_agent.isgeneralagent =="GA"
      if id != current_agent.generalagency.id
        redirect_to "/welcome"
        logger.warn "UNAUTHORIZED PERMISSION"
      end
    else
      if id != current_agent.agency.id
        redirect_to "/welcome"
        logger.warn "UNAUTHORIZED PERMISSION"
      end
    end
  end


  def ga_marshall
    if current_agent.isgeneralagent == "GA"

    else
      redirect_to "/welcome"
    end
  end


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
