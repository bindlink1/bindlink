function HandlePlaceholder(e){if("undefined"==typeof e.placeholder){var t=e.getAttribute("placeholder");t&&0<t.length&&(e.value=t,e.setAttribute("old_color",e.style.color),e.style.color="#c0c0c0",e.onfocus=function(){this.style.color=this.getAttribute("old_color"),this.value===t&&(this.value="")},e.onblur=function(){""===this.value&&(this.style.color="#c0c0c0",this.value=t)})}}window.onload=function(){for(var e=document.getElementsByTagName("input"),t=0;t<e.length;t++){var l=e[t];l.type&&""!=l.type&&"text"!=l.type||HandlePlaceholder(l)}};