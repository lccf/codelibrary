/*
 * auther: leaf
 * date:   11/25/2014 23:35
 */

/* storage module {{{ */
_storageData = {}
_stor = (key, value, force, destroy) ->
  data = _storageData

  if value is void
    return data[key]

  if destroy
    delete data[key]
    return true

  if not force and _.has data, key
    return false

  data[key] = value

/* }}} */

startGame = !->
  # collie.util.addEventListener window, 'load', !->
  useRetina = true
  getRetinaSize = (value) ->
    if useRetina
      value / 2
    else
      value

  imgPath = \img

  originWidth = 640
  originHeight = 960
  if useRetina
    originWidth = 640 / 2
    originHeight = 960 / 2
  layerWidth = Math.min window.innerWidth, 480
  layerRate = layerWidth / originWidth

  layerHeight = parseInt originHeight * layerRate
  layerHeightOffset = window.innerHeight - layerHeight
  layerHeight = Math.min layerHeight, window.innerHeight
  layerHeight = Math.max layerHeight, 400

  hamsterWidth = 268
  hamsterHeight = 238
  if useRetina
    hamsterWidth = 268 / 2
    hamsterHeight = 238 / 2
  hamsterRate = hamsterHeight / hamsterWidth
  # imgWidth = parseInt layerWidth * 0.4343

  # timeCountNum = 30
  timeCountNum = window.playMaxTime || 30

  maxActive = window.playMaxActive || 2
  maxCount = window.playMaxCount || 10

  init = !->
    # $ 'html, body' .css do
    #   height: '100%'
    #   minHeight: 520

    if layerHeightOffset > 0
      $ \#gameContainer .css 'margin-top', layerHeightOffset

    layer = new collie.Layer do
      width: layerWidth
      height: layerHeight

    # fpsInfo = new collie.FPSConsole do
    #   color: \red

    # /* back {{{ */
    # back = new collie.DisplayObject do
    #   x: \center
    #   y: 0
    #   width: layerWidth
    #   height: layerHeight
    #   fitImage: true
    #   backgroundImage: \back
    # .addTo layer
    #
    # back_end = new collie.DisplayObject do
    #   x: 0
    #   y: 0
    #   width: layerWidth
    #   height: layerHeight
    #   fitImage: true
    #   backgroundImage: \end
    #   visible: false
    #   zIndex: 40
    # .addTo layer
    #
    # showBackEnd = !->
    #   back_end.set \visible, true
    # /* }}} */
    /* hit Text {{{ */
    class HitCount
      (option) ->
        countText = new collie.Text do
          width: 140
          height: 40
          x: \right
          y: 10
          fontColor: \red
          count: 0
          zIndex: 50
          visible: false
        .addTo option.layer

        @handler = countText
        @_show!

        @

      _show: ->
        countText = @handler
        count = countText.get \count
        # countText.text "Count: #count"

      add: ->
        countText = @handler
        count = countText.get \count
        countText.set \count, ++count
        hitCountNumer.setValue count
        # countText.text "Count: #count"

      getCount: ->
        @handler.get \count

    hitCount = new HitCount do
      layer: layer
    /* }}} */
    /* Hamster class {{{ */
    class Hamster
      (option) ->
        hamster = new collie.DisplayObject do
          x: option.x, y: option.y
          width: hamsterWidth, height: hamsterHeight
          scaleX: layerRate, scaleY: layerRate
          originX: 0, originY: 0
          hitArea: [[0, getRetinaSize(40)], [getRetinaSize(134), getRetinaSize(40)], [getRetinaSize(134), getRetinaSize(236)], [0, getRetinaSize(236)], [0, getRetinaSize(40)]]
          # fitImage: true
          state: \normal
        .addTo option.layer

        hamster_show = new collie.DisplayObject do
          x: 0
          y: 0
          width: hamsterWidth
          height: hamsterHeight
          offsetX: getRetinaSize 300
          offsetY: getRetinaSize 250
          backgroundImage: \hamster
          visible: false
        .addTo hamster

        hamster_hit = new collie.DisplayObject do
          x: 0
          y: 0
          width: hamsterWidth
          height: hamsterHeight
          offsetX: getRetinaSize 300
          offsetY: 0
          backgroundImage: \hamster
          visible: false
        .addTo hamster

        timer = collie.Timer.repeat (e)!~>
          @hide!
        , 500, do
          loop: 1
          beforeDelay: 500

        timer.pause!

        hamster.set \showHandler, hamster_show
        hamster.set \hitHandler, hamster_hit
        hamster.set \timer, timer

        @handler = hamster
        @hash = +new Date!

        @_bindEvent!
        @

      _bindEvent: ->
        hamster = @handler

        hamster.attach \click, (e) !~>
          state = hamster.get \state
          if state is \active
            hitCount.add!
            @hit!

        @

      _state: (state=false) ->
        hamster = @handler
        if state
          hamster.set \state, state
        else
          hamster.get \state

      getState: ->
        @_state!

      setState: (state) ->
        @_state state

      _operation: (cmd) ->
        hamster = @handler
        hamster_show = hamster.get \showHandler
        hamster_hit = hamster.get \hitHandler
        if cmd is \show
          hamster_show.set \visible, true
          hamster_hit.set \visible, false
          @setState \active
        else if cmd is \hide
          hamster_show.set \visible, false
          hamster_hit.set \visible, false
          @setState \normal
          _stor(\endHamster) @
        else if cmd is \hit
          hamster_show.set \visible, false
          hamster_hit.set \visible, true
          @setState \hit
          hamster.get \timer .start!
        @

      show: ->
        @_operation \show
      hide: (notForce=false) !->
        if notForce
          if @getState! is \active
            @_operation \hide
        else
          @_operation \hide

      hit: ->
        @_operation \hit
        # 最大粉数判断
        count = hitCount.getCount!
        if count >= maxCount
          # console.log 'credit over'
          endCallback count, maxCount
    /* }}} */
    /* init hamster {{{ */
    hamster_array  = []
    hamster_active = []

    initHamster = ->
      position =
        * x: 106
          y: 242
        * x: 388
          y: 242
        * x: 106
          y: 502
        * x: 388
          y: 502

      for item in position
        y = parseInt getRetinaSize(item.y) * layerRate
        if layerHeightOffset < 0
          y += layerHeightOffset

        hamster = new Hamster do
          x     : parseInt getRetinaSize(item.x) * layerRate
          y     : y
          layer : layer
        hamster_array.push hamster
    /* }}} */
    /* info {{{ */
    letterSpacing = -10
    bottomTextHeight = 32
    if useRetina
      letterSpacing = 0
      bottomTextHeight = 24
    timeLabelText = new collie.DisplayObject do
      x: parseInt(getRetinaSize(40) * layerRate)
      y: \bottom
      scaleX: layerRate, scaleY: layerRate
      width: getRetinaSize(100), height: bottomTextHeight
      originX: 0, originY: 0
      offsetX: 0, offsetY: getRetinaSize 50
      backgroundImage: \countTextImg
    .addTo layer

    timeCountNumber = new collie.ImageNumber do
      x: parseInt(getRetinaSize(148) * layerRate)
      y: \bottom
      width: getRetinaSize 100
      height: bottomTextHeight
      letterSpacing: letterSpacing
    .number do
      width: getRetinaSize 22
      height: bottomTextHeight
      scaleX: layerRate, scaleY: layerRate
      originX: 0, originY: 0
      backgroundImage: \countTextImg
    .addTo layer

    timeCountNumber.setValue 30

    hitLabelText = new collie.DisplayObject do
      x: parseInt(getRetinaSize(240) * layerRate)
      y: \bottom
      scaleX: layerRate, scaleY: layerRate
      width: getRetinaSize(100), height: bottomTextHeight
      originX: 0, originY: 0
      offsetX: 0, offsetY: getRetinaSize 100
      backgroundImage: \countTextImg
    .addTo layer

    hitCountNumer = new collie.ImageNumber do
      x: parseInt(getRetinaSize(348) * layerRate)
      y: \bottom
      width: getRetinaSize 100
      height: bottomTextHeight
      letterSpacing: letterSpacing
    .number do
      width: getRetinaSize 22
      height: bottomTextHeight
      scaleX: layerRate, scaleY: layerRate
      originX: 0, originY: 0
      backgroundImage: \countTextImg
    .addTo layer

    hitCountNumer.setValue 0
    /* }}} */
    /* time count down {{{ */
    timeCountDownText = new collie.Text do
      width: 80
      height: 40
      x: \right
      y: 10
      fontColor: \red
      zIndex: 50
      visible: false
    .addTo layer

    timeCountDownText.text timeCountNum

    timeCountDown = collie.Timer.repeat (e) !->
      text = timeCountDownText
      text.text "Time: #{timeCountNum - e.count}"
      # 显示剩余时间
      timeCountNumber.setValue timeCountNum - e.count
      if timeCountNum - e.count <= 0
        e.timer.pause!
        e.timer.stop!
        # showBackEnd!
        endCallback hitCount.getCount!, maxCount
    , 1000

    timeCountDown.pause!
    /* }}} */

    # oTimer = collie.Timer.cycle (e) !->
    #   if e.value is 0
    #     hamster_key = Math.floor(Math.random() * hamster_array.length);
    #     hamster_active = hamster_array[hamster_key];
    #     hamster_active.show();
    #     _stor \hamster_active, hamster_active, 1
    #   else if e.value is 3
    #     hamster_active = _stor \hamster_active
    #     if hamster_active
    #       hamster_active.hide!
    #       _stor \hamster_active, false, 1
    # , 4000, do
    #
    #   from: 0
    #   to: 3
    #   step: 1
    #   start: 0
    #   loop: 1

    startHamster = !->
      if hamster_active.length < maxActive
        hamster_key = Math.floor(Math.random() * hamster_array.length)
        hamster = hamster_array.splice(hamster_key, 1)[0]
        hamster.show!
        hamster_active.push hamster

    endHamster = (hamster)!->
      for item, key in hamster_active
        if item is hamster
          hamster_array.push hamster_active.splice(key, 1)[0]
          break

    _stor 'endHamster', endHamster, true

    globalTimer = collie.Timer.repeat (e) !->
      rand = parseInt Math.random() * 10
      if rand > 5
        startHamster!
        # console.log \start
        # oTimer.start!
    , 500, do
      beforeDelay: 500

    stopAll = !->
      globalTimer.stop!
      timeCountDown.stop!
      timeCountNumber.setValue 0
      while hamster_active.length
        hamster = hamster_active.shift()
        hamster.hide true
        hamster_array.push hamster

    _stor \stopAll, stopAll, true

    # oTimer.pause!
    globalTimer.pause!
    # fpsInfo.load!
    /* initBrand {{{ */
    initBrand = !->
      x = parseInt getRetinaSize(35) * layerRate
      y = parseInt getRetinaSize(35) * layerRate
      # if layerHeightOffset < 0
      #   y += layerHeightOffset
      brand = new collie.DisplayObject do
        x: parseInt x * layerRate
        y: parseInt y * layerRate
        scaleX: layerRate, scaleY: layerRate
        width: getRetinaSize(330), height: getRetinaSize 360
        offsetX: getRetinaSize(570), offsetY: 0
        originX: 0, originY: 0
        backgroundImage: \hamster
      .addTo layer

    initHole = !->
      position =
        * x: 55
          y: 440
        * x: 340
          y: 440
        * x: 55
          y: 700
        * x: 340
          y: 700
      for item in position
        y = parseInt getRetinaSize(item.y) * layerRate
        if layerHeightOffset < 0
          y += layerHeightOffset
        hole = new collie.DisplayObject do
          x: parseInt getRetinaSize(item.x) * layerRate
          y: y
          scaleX: layerRate, scaleY: layerRate
          width: getRetinaSize(300), height: getRetinaSize 120
          offsetX: getRetinaSize(600), offsetY: getRetinaSize 380
          originX: 0, originY: 0
          backgroundImage: \hamster
        .addTo layer
    /* }}} */

    collie.Renderer.attach \start, !->
      initBrand!
      initHole!
      initHamster!
      globalTimer.start!
      timeCountDown.start!

    # debug {{{
    # layer.attach \mousedown, (e) !->
    #   console.log \mousedown
    #   console.log e
    # layer.attach \mouseup, (e) !->
    #   console.log \mouseup
    #   console.log e

    # initHole!

    # layer.attach \click, !->
    #   console.log \click
    # }}}

    collie.Renderer.addLayer layer
    collie.Renderer.load document.getElementById \gameContainer
    collie.Renderer.start \30fps

  endCallback = (count, maxCount) !->
    _stor(\stopAll)!
    if window.playEndCallback
      playEndCallback count, maxCount

  collie.Renderer.RETINA_DISPLAY = useRetina
  # collie.Renderer.DEBUG_RENDERING_MODE = \dom

  collie.ImageManager.add do
    hamster: "#imgPath/bg_hamster.png"
    countTextImg: "#imgPath/bg_count_text.png"
    , init

class imagePreload
  (imgs, tick, callback) ->
    unless imgs.length
      return

    @tick = tick
    @callback = callback
    @loadImgArray = []
    @imgArray = imgs
    @imgCount = imgs.length
    @imgLoaded = 0

    @init!

    @

  init: ->
    self = this
    call = !->
      self.loadcall @getAttribute \imgUrl

    for imgUrl in @imgArray
      img = new Image(1, 1)
      img.setAttribute \imgUrl, imgUrl
      img.onload = call
      img.src = imgUrl

  loadcall: (imgUrl) !->
    for url in @imgArray
      if url is imgUrl
        @imgLoaded += 1
        if @tick
          @tick imgUrl, @imgLoaded, @imgCount
        if @imgLoaded is @imgCount and @callback
          @callback()
        break

imagePreload.load = (imgs, tick, callback) ->
  new imagePreload imgs, tick, callback

/* vim: se sw=2 ts=2 sts=2 fdm=marker et: */
