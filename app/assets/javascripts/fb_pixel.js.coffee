# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
((f, b, e, v, n, t, s) ->
  if f.fbq
    return
  n =
  f.fbq = ->
    if n.callMethod then n.callMethod.apply(n, arguments) else n.queue.push(arguments)
    return

  if !f._fbq
    f._fbq = n
  n.push = n
  n.loaded = !0
  n.version = '2.0'
  n.queue = []
  t = b.createElement(e)
  t.async = !0
  t.src = v
  s = b.getElementsByTagName(e)[0]
  s.parentNode.insertBefore t, s
  return
)(window, document, 'script', 'https://connect.facebook.net/en_US/fbevents.js')
fbq 'init', '252482198497323'
fbq 'track', 'PageView'