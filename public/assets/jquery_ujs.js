!function(c,m){var f;(function(){var e=c._data(document,"events");return e&&e.click&&c.grep(e.click,function(e){return"rails"===e.namespace}).length})()&&c.error("jquery-ujs has already been loaded!"),c.rails=f={linkClickSelector:"a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]",inputChangeSelector:"select[data-remote], input[data-remote], textarea[data-remote]",formSubmitSelector:"form",formInputClickSelector:"form input[type=submit], form input[type=image], form button[type=submit], form button:not([type])",disableSelector:"input[data-disable-with], button[data-disable-with], textarea[data-disable-with]",enableSelector:"input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled",requiredInputSelector:"input[name][required]:not([disabled]),textarea[name][required]:not([disabled])",fileInputSelector:"input:file",linkDisableSelector:"a[data-disable-with]",CSRFProtection:function(e){var t=c('meta[name="csrf-token"]').attr("content");t&&e.setRequestHeader("X-CSRF-Token",t)},fire:function(e,t,a){var n=c.Event(t);return e.trigger(n,a),!1!==n.result},confirm:function(e){return confirm(e)},ajax:function(e){return c.ajax(e)},href:function(e){return e.attr("href")},handleRemote:function(n){var e,t,a,r,i,o,l,u;if(f.fire(n,"ajax:before")){if(i=(r=n.data("cross-domain"))===m?null:r,o=n.data("with-credentials")||null,l=n.data("type")||c.ajaxSettings&&c.ajaxSettings.dataType,n.is("form")){e=n.attr("method"),t=n.attr("action"),a=n.serializeArray();var d=n.data("ujs:submit-button");d&&(a.push(d),n.data("ujs:submit-button",null))}else n.is(f.inputChangeSelector)?(e=n.data("method"),t=n.data("url"),a=n.serialize(),n.data("params")&&(a=a+"&"+n.data("params"))):(e=n.data("method"),t=f.href(n),a=n.data("params")||null);u={type:e||"GET",data:a,dataType:l,beforeSend:function(e,t){return t.dataType===m&&e.setRequestHeader("accept","*/*;q=0.5, "+t.accepts.script),f.fire(n,"ajax:beforeSend",[e,t])},success:function(e,t,a){n.trigger("ajax:success",[e,t,a])},complete:function(e,t){n.trigger("ajax:complete",[e,t])},error:function(e,t,a){n.trigger("ajax:error",[e,t,a])},xhrFields:{withCredentials:o},crossDomain:i},t&&(u.url=t);var s=f.ajax(u);return n.trigger("ajax:send",s),s}return!1},handleMethod:function(e){var t=f.href(e),a=e.data("method"),n=e.attr("target"),r=c("meta[name=csrf-token]").attr("content"),i=c("meta[name=csrf-param]").attr("content"),o=c('<form method="post" action="'+t+'"></form>'),l='<input name="_method" value="'+a+'" type="hidden" />';i!==m&&r!==m&&(l+='<input name="'+i+'" value="'+r+'" type="hidden" />'),n&&o.attr("target",n),o.hide().append(l).appendTo("body"),o.submit()},disableFormElements:function(e){e.find(f.disableSelector).each(function(){var e=c(this),t=e.is("button")?"html":"val";e.data("ujs:enable-with",e[t]()),e[t](e.data("disable-with")),e.prop("disabled",!0)})},enableFormElements:function(e){e.find(f.enableSelector).each(function(){var e=c(this),t=e.is("button")?"html":"val";e.data("ujs:enable-with")&&e[t](e.data("ujs:enable-with")),e.prop("disabled",!1)})},allowAction:function(e){var t,a=e.data("confirm"),n=!1;return!a||(f.fire(e,"confirm")&&(n=f.confirm(a),t=f.fire(e,"confirm:complete",[n])),n&&t)},blankInputs:function(e,t,a){var n,r=c(),i=t||"input,textarea",o=e.find(i);return o.each(function(){if(n=c(this),!(n.is(":checkbox,:radio")?n.is(":checked"):n.val())==!a){if(n.is(":radio")&&o.filter('input:radio:checked[name="'+n.attr("name")+'"]').length)return!0;r=r.add(n)}}),!!r.length&&r},nonBlankInputs:function(e,t){return f.blankInputs(e,t,!0)},stopEverything:function(e){return c(e.target).trigger("ujs:everythingStopped"),e.stopImmediatePropagation(),!1},callFormSubmitBindings:function(e,a){var t=e.data("events"),n=!0;return t!==m&&t.submit!==m&&c.each(t.submit,function(e,t){if("function"==typeof t.handler)return n=t.handler(a)}),n},disableElement:function(e){e.data("ujs:enable-with",e.html()),e.html(e.data("disable-with")),e.bind("click.railsDisable",function(e){return f.stopEverything(e)})},enableElement:function(e){e.data("ujs:enable-with")!==m&&(e.html(e.data("ujs:enable-with")),e.data("ujs:enable-with",!1)),e.unbind("click.railsDisable")}},f.fire(c(document),"rails:attachBindings")&&(c.ajaxPrefilter(function(e,t,a){e.crossDomain||f.CSRFProtection(a)}),c(document).delegate(f.linkDisableSelector,"ajax:complete",function(){f.enableElement(c(this))}),c(document).delegate(f.linkClickSelector,"click.rails",function(e){var t=c(this),a=t.data("method"),n=t.data("params");if(!f.allowAction(t))return f.stopEverything(e);if(t.is(f.linkDisableSelector)&&f.disableElement(t),t.data("remote")===m)return t.data("method")?(f.handleMethod(t),!1):void 0;if((e.metaKey||e.ctrlKey)&&(!a||"GET"===a)&&!n)return!0;var r=f.handleRemote(t);return!1===r?f.enableElement(t):r.error(function(){f.enableElement(t)}),!1}),c(document).delegate(f.inputChangeSelector,"change.rails",function(e){var t=c(this);return f.allowAction(t)?(f.handleRemote(t),!1):f.stopEverything(e)}),c(document).delegate(f.formSubmitSelector,"submit.rails",function(e){var t=c(this),a=t.data("remote")!==m,n=f.blankInputs(t,f.requiredInputSelector),r=f.nonBlankInputs(t,f.fileInputSelector);if(!f.allowAction(t))return f.stopEverything(e);if(n&&t.attr("novalidate")==m&&f.fire(t,"ajax:aborted:required",[n]))return f.stopEverything(e);if(a){if(r){setTimeout(function(){f.disableFormElements(t)},13);var i=f.fire(t,"ajax:aborted:file",[r]);return i||setTimeout(function(){f.enableFormElements(t)},13),i}return!c.support.submitBubbles&&c().jquery<"1.7"&&!1===f.callFormSubmitBindings(t,e)?f.stopEverything(e):(f.handleRemote(t),!1)}setTimeout(function(){f.disableFormElements(t)},13)}),c(document).delegate(f.formInputClickSelector,"click.rails",function(e){var t=c(this);if(!f.allowAction(t))return f.stopEverything(e);var a=t.attr("name"),n=a?{name:a,value:t.val()}:null;t.closest("form").data("ujs:submit-button",n)}),c(document).delegate(f.formSubmitSelector,"ajax:beforeSend.rails",function(e){this==e.target&&f.disableFormElements(c(this))}),c(document).delegate(f.formSubmitSelector,"ajax:complete.rails",function(e){this==e.target&&f.enableFormElements(c(this))}),c(function(){csrf_token=c("meta[name=csrf-token]").attr("content"),csrf_param=c("meta[name=csrf-param]").attr("content"),c('form input[name="'+csrf_param+'"]').val(csrf_token)}))}(jQuery);