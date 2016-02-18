###[formatUrlParam] 格式化url参数 {{{###
formatUrlParam = (url = '') ->
  url = url.replace /^\?/, ''
  paramObject = {}
  if url && url.length > 1
    urlparam = url.split('&')
  else
    urlparam = []

  for item, key in urlparam
    [key, value] = item.split '='
    key = key.replace /\[\]$/, ''
    # fix 被传入unicode编码导致decodeURIComponent报错的情况
    if value.match(/%u\w{4}/) isnt null
      value = value.replace /%u\w{4}/g, (char) -> unescape char
    value = decodeURIComponent value
    if value is ''
      continue
    if _.has paramObject, key
      if _.isArray paramObject[key]
        paramObject[key].push value
      else
        paramObject[key] = [paramObject[key], value]
    else
      paramObject[key] = value

  paramObject
###}}}###
