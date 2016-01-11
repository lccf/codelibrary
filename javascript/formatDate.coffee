formatDate = (date, fmt) ->
  o =
    'M+': date.getMonth() + 1
    'd+': date.getDate()
    'h+': date.getHours()
    'm+': date.getMinutes()
    's+': date.getSeconds()
    'q+': Math.floor((date.getMonth() + 3) / 3)
    'S': date.getMilliseconds()
  if /(y+)/.test(fmt)
    fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - (RegExp.$1.length)))
  for k of o
    if new RegExp('(' + k + ')').test(fmt)
      fmt = fmt.replace(RegExp.$1, if RegExp.$1.length == 1 then o[k] else ('00' + o[k]).substr(('' + o[k]).length))
  fmt
