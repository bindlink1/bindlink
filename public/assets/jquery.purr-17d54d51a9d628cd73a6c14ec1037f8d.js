/**
 * jquery.purr.js
 * Copyright (c) 2008 Net Perspective (net-perspective.com)
 * Licensed under the MIT License (http://www.opensource.org/licenses/mit-license.php)
 *
 * @author R.A. Ray
 * @projectDescription  jQuery plugin for dynamically displaying unobtrusive messages in the browser. Mimics the behavior of the MacOS program "Growl."
 * @version 0.1.0
 *
 * @requires jquery.js (tested with 1.2.6)
 *
 * @param fadeInSpeed           int - Duration of fade in animation in miliseconds
 *                          default: 500
 *  @param fadeOutSpeed         int - Duration of fade out animationin miliseconds
                            default: 500
 *  @param removeTimer          int - Timeout, in miliseconds, before notice is removed once it is the top non-sticky notice in the list
                            default: 4000
 *  @param isSticky             bool - Whether the notice should fade out on its own or wait to be manually closed
                            default: false
 *  @param usingTransparentPNG  bool - Whether or not the notice is using transparent .png images in its styling
                            default: false
 */
!function(u){u.purr=function(t,r){function e(){var e=document.createElement("a");if(u(e).attr({"class":"close",href:"#close"}).appendTo(t).click(function(){return i(),!1}),u(document).keyup(function(e){27===e.keyCode&&i()}),t.appendTo(a).hide(),t.fadeIn(r.fadeInSpeed),!r.isSticky)var n=setInterval(function(){0===t.prevAll(".purr").length&&(clearInterval(n),setTimeout(function(){i()},r.removeTimer))},200)}function i(){t.animate({opacity:"0"},{duration:r.fadeOutSpeed,complete:function(){t.animate({height:"0px"},{duration:r.fadeOutSpeed,complete:function(){t.remove()}})}})}(t=u(t)).addClass("purr");var a=document.getElementById("purr-container");a||(a='<div id="purr-container"></div>'),a=u(a),u("body").append(a),e()},u.fn.purr=function(e){return(e=e||{}).fadeInSpeed=e.fadeInSpeed||500,e.fadeOutSpeed=e.fadeOutSpeed||500,e.removeTimer=e.removeTimer||4e3,e.isSticky=e.isSticky||!1,e.usingTransparentPNG=e.usingTransparentPNG||!1,this.each(function(){new u.purr(this,e)}),this}}(jQuery);