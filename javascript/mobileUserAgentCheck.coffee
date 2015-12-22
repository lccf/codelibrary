_func = {}

try
  _ua = navigator.userAgent.match(/(\([^)]*\))/g)[0]
catch
  _ua = ''

_func.isAndroid = ->
  /Linux/i.test(_ua) and /Android/i.test _ua

_func.isIOS = ->
  /i(Phone|P(o|a)d)/i.test _ua

_func.isIPad = ->
  /iPad/i.test _ua

_func.isIPhone = ->
  /iPhone/i.test _ua

_func.isWP = ->
  /Windows Phone/i.test _ua
