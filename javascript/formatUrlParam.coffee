###[formatUrlParam] 格式化url参数 {{{###
formatUrlParam = (url = '') ->
  url = url.replace /^\?/, ''
  paramObject = {}
  if url && url.length > 1
    urlparam = url.split('&')
  else
    urlparam = []

  for item in urlparam
    [key, value] = item.split '='
    if not key
      continue
    key = key.replace /\[\]$/, ''
    if value
      # fix 被传入unicode编码的情况
      if value.match(/%u\w{4}/) isnt null
        value = value.replace /%u\w{4}/g, (char) -> unescape char
      value = decodeURIComponent value
    else
      value = ''
    if _.has paramObject, key
      if _.isArray paramObject[key]
        paramObject[key].push value
      else
        paramObject[key] = [paramObject[key], value]
    else
      paramObject[key] = value

  paramObject
###}}}###
