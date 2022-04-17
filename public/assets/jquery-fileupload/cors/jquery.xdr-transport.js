/*
 * jQuery XDomainRequest Transport Plugin 1.1.3
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2011, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 *
 * Based on Julian Aubourg's ajaxHooks xdr.js:
 * https://github.com/jaubourg/ajaxHooks/
 */
!function(t){"use strict";"function"==typeof define&&define.amd?define(["jquery"],t):t(window.jQuery)}(function(i){"use strict";window.XDomainRequest&&!i.support.cors&&i.ajaxTransport(function(n){var r;if(n.crossDomain&&n.async)return n.timeout&&(n.xdrTimeout=n.timeout,delete n.timeout),{send:function(t,u){function o(t,o,e,n){r.onload=r.onerror=r.ontimeout=i.noop,r=null,u(t,o,e,n)}var e=/\?/.test(n.url)?"&":"?";r=new XDomainRequest,"DELETE"===n.type?(n.url=n.url+e+"_method=DELETE",n.type="POST"):"PUT"===n.type?(n.url=n.url+e+"_method=PUT",n.type="POST"):"PATCH"===n.type&&(n.url=n.url+e+"_method=PATCH",n.type="POST"),r.open(n.type,n.url),r.onload=function(){o(200,"OK",{text:r.responseText},"Content-Type: "+r.contentType)},r.onerror=function(){o(404,"Not Found")},n.xdrTimeout&&(r.ontimeout=function(){o(0,"timeout")},r.timeout=n.xdrTimeout),r.send(n.hasContent&&n.data||null)},abort:function(){r&&(r.onerror=i.noop(),r.abort())}}})});