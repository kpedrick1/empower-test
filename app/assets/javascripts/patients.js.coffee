//= require_tree ./patients


$ ->

  ml = $("#main-layout").height()
  bl = $("#bar-layout").height()

  if ml > bl
    $("#bar-layout").height ml


  

  
