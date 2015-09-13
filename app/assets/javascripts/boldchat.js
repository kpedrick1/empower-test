window._bcvma = window._bcvma || [];
_bcvma.push(["setAccountID", "129061380871830311"]);
_bcvma.push(["setParameter", "WebsiteID", "2887201180414898532"]);
_bcvma.push(["setParameter", "InvitationID", "128409265680984403"]);
_bcvma.push(["pageViewed"]);
var bcLoad = function(){
    if(window.bcLoaded) return; window.bcLoaded = true;
    var vms = document.createElement("script"); vms.type = "text/javascript"; vms.async = true;
    vms.src = ('https:'==document.location.protocol?'https://':'http://') + "vmss.boldchat.com/aid/129061380871830311/bc.vms4/vms.js";
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(vms, s);
};
if(window.pageViewer && pageViewer.load) pageViewer.load();
else if(document.readyState=="complete") bcLoad();
else if(window.addEventListener) window.addEventListener('load', bcLoad, false);
else window.attachEvent('onload', bcLoad);