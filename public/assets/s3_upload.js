function s3_swf_init(e,t){var n=t.buttonWidth!=undefined?t.buttonWidth:50,i=t.buttonHeight!=undefined?t.buttonHeight:50,o=t.flashVersion!=undefined?t.flashVersion:"9.0.0",a=t.queueSizeLimit!=undefined?t.queueSizeLimit:10,r=t.fileSizeLimit!=undefined?t.fileSizeLimit:524288e3,l=t.fileTypes!=undefined?t.fileTypes:"*.*",s=t.fileTypeDescs!=undefined?t.fileTypeDescs:"All Files",u=t.selectMultipleFiles==undefined||t.selectMultipleFiles,d=t.keyPrefix!=undefined?t.keyPrefix:"",f=t.signaturePath!=undefined?t.signaturePath:"s3_uploads.xml",c=t.swfFilePath!=undefined?t.swfFilePath:"/flash/s3_upload.swf",p=t.buttonUpPath!=undefined?t.buttonUpPath:"",h=t.buttonOverPath!=undefined?t.buttonOverPath:"",v=t.buttonDownPath!=undefined?t.buttonDownPath:"",g=t.onFileAdd!=undefined?t.onFileAdd:function(){},y=t.onFileRemove!=undefined?t.onFileRemove:function(){},m=t.onFileSizeLimitReached!=undefined?t.onFileSizeLimitReached:function(){},w=t.onFileNotInQueue!=undefined?t.onFileNotInQueue:function(){},S=t.onQueueChange!=undefined?t.onQueueChange:function(){},b=t.onQueueClear!=undefined?t.onQueueClear:function(){},E=t.onQueueSizeLimitReached!=undefined?t.onQueueSizeLimitReached:function(){},C=t.onQueueEmpty!=undefined?t.onQueueEmpty:function(){},F=t.onUploadingStop!=undefined?t.onUploadingStop:function(){},U=t.onUploadingStart!=undefined?t.onUploadingStart:function(){},I=t.onUploadingFinish!=undefined?t.onUploadingFinish:function(){},L=t.onSignatureOpen!=undefined?t.onSignatureOpen:function(){},O=t.onSignatureProgress!=undefined?t.onSignatureProgress:function(){},T=t.onSignatureHttpStatus!=undefined?t.onSignatureHttpStatus:function(){},A=t.onSignatureComplete!=undefined?t.onSignatureComplete:function(){},N=t.onSignatureSecurityError!=undefined?t.onSignatureSecurityError:function(){},j=t.onSignatureIOError!=undefined?t.onSignatureIOError:function(){},P=t.onSignatureXMLError!=undefined?t.onSignatureXMLError:function(){},k=t.onUploadOpen!=undefined?t.onUploadOpen:function(){},Q=t.onUploadProgress!=undefined?t.onUploadProgress:function(){},B=t.onUploadHttpStatus!=undefined?t.onUploadHttpStatus:function(){},x=t.onUploadComplete!=undefined?t.onUploadComplete:function(){},M=t.onUploadIOError!=undefined?t.onUploadIOError:function(){},R=t.onUploadSecurityError!=undefined?t.onUploadSecurityError:function(){},V=t.onUploadError!=undefined?t.onUploadError:function(){},$={s3_swf_obj:t.swfVarObj!=undefined?t.swfVarObj:"s3_swf"},_={},z={};_.wmode="transparent",_.menu="false",_.quality="low",s3_upload_swfobject.embedSWF(c+"?t="+(new Date).getTime(),e,n,i,o,!1,$,_,z);var H=window.location.protocol+"//"+window.location.host+f,D=window.location.protocol+"//"+window.location.host+p,W=window.location.protocol+"//"+window.location.host+v,X=window.location.protocol+"//"+window.location.host+h;return s3_swf={obj:function(){return document[e]},init:function(){this.obj().init(H,d,r,a,l,s,u,n,i,D,W,X)},clearQueue:function(){this.obj().clearQueue()},startUploading:function(){this.obj().startUploading()},stopUploading:function(){this.obj().stopUploading()},removeFileFromQueue:function(e){this.obj().removeFileFromQueue(e)},onFileAdd:g,onFileRemove:y,onFileSizeLimitReached:m,onFileNotInQueue:w,onQueueChange:S,onQueueClear:b,onQueueSizeLimitReached:E,onQueueEmpty:C,onUploadingStop:F,onUploadingStart:U,onUploadingFinish:I,onSignatureOpen:L,onSignatureProgress:O,onSignatureHttpStatus:T,onSignatureComplete:A,onSignatureSecurityError:N,onSignatureIOError:j,onSignatureXMLError:P,onUploadOpen:k,onUploadProgress:Q,onUploadHttpStatus:B,onUploadComplete:x,onUploadIOError:M,onUploadSecurityError:R,onUploadError:V}}var s3_swf,s3_upload_swfobject=function(){function t(){if(!z){try{var e=B.getElementsByTagName("body")[0].appendChild(g("span"));e.parentNode.removeChild(e)}catch(i){return}z=!0;for(var t=R.length,n=0;n<t;n++)R[n]()}}function e(e){z?e():R[R.length]=e}function n(e){if(typeof Q.addEventListener!=O)Q.addEventListener("load",e,!1);else if(typeof B.addEventListener!=O)B.addEventListener("load",e,!1);else if(typeof Q.attachEvent!=O)u(Q,"onload",e);else if("function"==typeof Q.onload){var t=Q.onload;Q.onload=function(){t(),e()}}else Q.onload=e}function i(){M?o():a()}function o(){var t=B.getElementsByTagName("body")[0],n=g(T);n.setAttribute("type",j);var i=t.appendChild(n);if(i){var o=0;!function(){if(typeof i.GetVariable!=O){var e=i.GetVariable("$version");e&&(e=e.split(" ")[1].split(","),W.pv=[parseInt(e[0],10),parseInt(e[1],10),parseInt(e[2],10)])}else if(o<10)return o++,setTimeout(arguments.callee,10);t.removeChild(n),i=null,a()}()}else a()}function a(){var e=V.length;if(0<e)for(var t=0;t<e;t++){var n=V[t].id,i=V[t].callbackFn,o={success:!1,id:n};if(0<W.pv[0]){var a=v(n);if(a)if(!S(V[t].swfVersion)||W.wk&&W.wk<312)if(V[t].expressInstall&&y()){var r={};r.data=V[t].expressInstall,r.width=a.getAttribute("width")||"0",r.height=a.getAttribute("height")||"0",a.getAttribute("class")&&(r.styleclass=a.getAttribute("class")),a.getAttribute("align")&&(r.align=a.getAttribute("align"));for(var l={},s=a.getElementsByTagName("param"),u=s.length,d=0;d<u;d++)"movie"!=s[d].getAttribute("name").toLowerCase()&&(l[s[d].getAttribute("name")]=s[d].getAttribute("value"));m(r,l,n,i)}else p(a),i&&i(o);else b(n,!0),i&&(o.success=!0,o.ref=c(n),i(o))}else if(b(n,!0),i){var f=c(n);f&&typeof f.SetVariable!=O&&(o.success=!0,o.ref=f),i(o)}}}function c(e){var t=null,n=v(e);if(n&&"OBJECT"==n.nodeName)if(typeof n.SetVariable!=O)t=n;else{var i=n.getElementsByTagName(T)[0];i&&(t=i)}return t}function y(){return!H&&S("6.0.65")&&(W.win||W.mac)&&!(W.wk&&W.wk<312)}function m(e,t,n,i){F=i||null,U={success:!(H=!0),id:n};var o=v(n);if(o){C="OBJECT"==o.nodeName?(E=s(o),null):(E=o,n),e.id=P,(typeof e.width==O||!/%$/.test(e.width)&&parseInt(e.width,10)<310)&&(e.width="310"),(typeof e.height==O||!/%$/.test(e.height)&&parseInt(e.height,10)<137)&&(e.height="137"),B.title=B.title.slice(0,47)+" - Flash Player Installation";var a=W.ie&&W.win?"ActiveX":"PlugIn",r="MMredirectURL="+Q.location.toString().replace(/&/g,"%26")+"&MMplayerType="+a+"&MMdoctitle="+B.title;if(typeof t.flashvars!=O?t.flashvars+="&"+r:t.flashvars=r,W.ie&&W.win&&4!=o.readyState){var l=g("div");n+="SWFObjectNew",l.setAttribute("id",n),o.parentNode.insertBefore(l,o),o.style.display="none",function(){4==o.readyState?o.parentNode.removeChild(o):setTimeout(arguments.callee,10)}()}w(e,t,n)}}function p(e){if(W.ie&&W.win&&4!=e.readyState){var t=g("div");e.parentNode.insertBefore(t,e),t.parentNode.replaceChild(s(e),t),e.style.display="none",function(){4==e.readyState?e.parentNode.removeChild(e):setTimeout(arguments.callee,10)}()}else e.parentNode.replaceChild(s(e),e)}function s(e){var t=g("div");if(W.win&&W.ie)t.innerHTML=e.innerHTML;else{var n=e.getElementsByTagName(T)[0];if(n){var i=n.childNodes;if(i)for(var o=i.length,a=0;a<o;a++)1==i[a].nodeType&&"PARAM"==i[a].nodeName||8==i[a].nodeType||t.appendChild(i[a].cloneNode(!0))}}return t}function w(e,t,n){var i,o=v(n);if(W.wk&&W.wk<312)return i;if(o)if(typeof e.id==O&&(e.id=n),W.ie&&W.win){var a="";for(var r in e)e[r]!=Object.prototype[r]&&("data"==r.toLowerCase()?t.movie=e[r]:"styleclass"==r.toLowerCase()?a+=' class="'+e[r]+'"':"classid"!=r.toLowerCase()&&(a+=" "+r+'="'+e[r]+'"'));var l="";for(var s in t)t[s]!=Object.prototype[s]&&(l+='<param name="'+s+'" value="'+t[s]+'" />');o.outerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'+a+">"+l+"</object>",$[$.length]=e.id,i=v(e.id)}else{var u=g(T);for(var d in u.setAttribute("type",j),e)e[d]!=Object.prototype[d]&&("styleclass"==d.toLowerCase()?u.setAttribute("class",e[d]):"classid"!=d.toLowerCase()&&u.setAttribute(d,e[d]));for(var f in t)t[f]!=Object.prototype[f]&&"movie"!=f.toLowerCase()&&h(u,f,t[f]);o.parentNode.replaceChild(u,o),i=u}return i}function h(e,t,n){var i=g("param");i.setAttribute("name",t),i.setAttribute("value",n),e.appendChild(i)}function r(e){var t=v(e);t&&"OBJECT"==t.nodeName&&(W.ie&&W.win?(t.style.display="none",function(){4==t.readyState?l(e):setTimeout(arguments.callee,10)}()):t.parentNode.removeChild(t))}function l(e){var t=v(e);if(t){for(var n in t)"function"==typeof t[n]&&(t[n]=null);t.parentNode.removeChild(t)}}function v(e){var t=null;try{t=B.getElementById(e)}catch(n){}return t}function g(e){return B.createElement(e)}function u(e,t,n){e.attachEvent(t,n),_[_.length]=[e,t,n]}function S(e){var t=W.pv,n=e.split(".");return n[0]=parseInt(n[0],10),n[1]=parseInt(n[1],10)||0,n[2]=parseInt(n[2],10)||0,t[0]>n[0]||t[0]==n[0]&&t[1]>n[1]||t[0]==n[0]&&t[1]==n[1]&&t[2]>=n[2]}function d(e,t,n,i){if(!W.ie||!W.mac){var o=B.getElementsByTagName("head")[0];if(o){var a=n&&"string"==typeof n?n:"screen";if(i&&(L=I=null),!I||L!=a){var r=g("style");r.setAttribute("type","text/css"),r.setAttribute("media",a),I=o.appendChild(r),W.ie&&W.win&&typeof B.styleSheets!=O&&0<B.styleSheets.length&&(I=B.styleSheets[B.styleSheets.length-1]),L=a}W.ie&&W.win?I&&typeof I.addRule==T&&I.addRule(e,t):I&&typeof B.createTextNode!=O&&I.appendChild(B.createTextNode(e+" {"+t+"}"))}}}function b(e,t){if(D){var n=t?"visible":"hidden";z&&v(e)?v(e).style.visibility=n:d("#"+e,"visibility:"+n)}}function f(e){return null!=/[\\\"<>\.;]/.exec(e)&&typeof encodeURIComponent!=O?encodeURIComponent(e):e}var E,C,F,U,I,L,O="undefined",T="object",A="Shockwave Flash",N="ShockwaveFlash.ShockwaveFlash",j="application/x-shockwave-flash",P="SWFObjectExprInst",k="onreadystatechange",Q=window,B=document,x=navigator,M=!1,R=[i],V=[],$=[],_=[],z=!1,H=!1,D=!0,W=function(){var e=typeof B.getElementById!=O&&typeof B.getElementsByTagName!=O&&typeof B.createElement!=O,t=x.userAgent.toLowerCase(),n=x.platform.toLowerCase(),i=n?/win/.test(n):/win/.test(t),o=n?/mac/.test(n):/mac/.test(t),a=!!/webkit/.test(t)&&parseFloat(t.replace(/^.*webkit\/(\d+(\.\d+)?).*$/,"$1")),r=!1,l=[0,0,0],s=null;if(typeof x.plugins!=O&&typeof x.plugins[A]==T)!(s=x.plugins[A].description)||typeof x.mimeTypes!=O&&x.mimeTypes[j]&&!x.mimeTypes[j].enabledPlugin||(r=!(M=!0),s=s.replace(/^.*\s+(\S+\s+\S+$)/,"$1"),l[0]=parseInt(s.replace(/^(.*)\..*$/,"$1"),10),l[1]=parseInt(s.replace(/^.*\.(.*)\s.*$/,"$1"),10),l[2]=/[a-zA-Z]/.test(s)?parseInt(s.replace(/^.*[a-zA-Z]+(.*)$/,"$1"),10):0);else if(typeof Q.ActiveXObject!=O)try{var u=new ActiveXObject(N);u&&(s=u.GetVariable("$version"))&&(r=!0,s=s.split(" ")[1].split(","),l=[parseInt(s[0],10),parseInt(s[1],10),parseInt(s[2],10)])}catch(d){}return{w3:e,pv:l,wk:a,ie:r,win:i,mac:o}}();W.w3&&((typeof B.readyState!=O&&"complete"==B.readyState||typeof B.readyState==O&&(B.getElementsByTagName("body")[0]||B.body))&&t(),z||(typeof B.addEventListener!=O&&B.addEventListener("DOMContentLoaded",t,!1),W.ie&&W.win&&(B.attachEvent(k,function(){"complete"==B.readyState&&(B.detachEvent(k,arguments.callee),t())}),Q==top&&function(){if(!z){try{B.documentElement.doScroll("left")}catch(e){return setTimeout(arguments.callee,0)}t()}}()),W.wk&&function(){z||(/loaded|complete/.test(B.readyState)?t():setTimeout(arguments.callee,0))}(),n(t))),W.ie&&W.win&&window.attachEvent("onunload",function(){for(var e=_.length,t=0;t<e;t++)_[t][0].detachEvent(_[t][1],_[t][2]);for(var n=$.length,i=0;i<n;i++)r($[i]);for(var o in W)W[o]=null;for(var a in W=null,swfobject)swfobject[a]=null;swfobject=null});return{registerObject:function(e,t,n,i){if(W.w3&&e&&t){var o={};o.id=e,o.swfVersion=t,o.expressInstall=n,o.callbackFn=i,V[V.length]=o,b(e,!1)}else i&&i({success:!1,id:e})},getObjectById:function(e){if(W.w3)return c(e)},embedSWF:function(r,l,s,u,d,f,c,p,h,v){var g={success:!1,id:l};W.w3&&!(W.wk&&W.wk<312)&&r&&l&&s&&u&&d?(b(l,!1),e(function(){s+="",u+="";var e={};if(h&&typeof h===T)for(var t in h)e[t]=h[t];e.data=r,e.width=s,e.height=u;var n={};if(p&&typeof p===T)for(var i in p)n[i]=p[i];if(c&&typeof c===T)for(var o in c)typeof n.flashvars!=O?n.flashvars+="&"+o+"="+c[o]:n.flashvars=o+"="+c[o];if(S(d)){var a=w(e,n,l);e.id==l&&b(l,!0),g.success=!0,g.ref=a}else{if(f&&y())return e.data=f,void m(e,n,l,v);b(l,!0)}v&&v(g)})):v&&v(g)},switchOffAutoHideShow:function(){D=!1},ua:W,getFlashPlayerVersion:function(){return{major:W.pv[0],minor:W.pv[1],release:W.pv[2]}},hasFlashPlayerVersion:S,createSWF:function(e,t,n){return W.w3?w(e,t,n):undefined},showExpressInstall:function(e,t,n,i){W.w3&&y()&&m(e,t,n,i)},removeSWF:function(e){W.w3&&r(e)},createCSS:function(e,t,n,i){W.w3&&d(e,t,n,i)},addDomLoadEvent:e,addLoadEvent:n,getQueryParamValue:function(e){var t=B.location.search||B.location.hash;if(t){if(/\?/.test(t)&&(t=t.split("?")[1]),null==e)return f(t);for(var n=t.split("&"),i=0;i<n.length;i++)if(n[i].substring(0,n[i].indexOf("="))==e)return f(n[i].substring(n[i].indexOf("=")+1))}return""},expressInstallCallback:function(){if(H){var e=v(P);e&&E&&(e.parentNode.replaceChild(E,e),C&&(b(C,!0),W.ie&&W.win&&(E.style.display="block")),F&&F(U)),H=!1}}}}();
/* S3_Upload V0.1
	Copyright (c) 2008 Elctech,
	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
*/
/* S3_Upload V0.2
	Copyright (c) 2010 Nathan Colgate,
	This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
*/