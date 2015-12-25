/*
 * auther: leaf
 * date:   11/25/2014 23:35
 */
/* storage module {{{ */
var _storageData, _stor, startGame, imagePreload;
_storageData = {};
_stor = function(key, value, force, destroy){
  var data;
  data = _storageData;
  if (value === void 8) {
    return data[key];
  }
  if (destroy) {
    delete data[key];
    return true;
  }
  if (!force && _.has(data, key)) {
    return false;
  }
  return data[key] = value;
};
/* }}} */
startGame = function(){
  var useRetina, getRetinaSize, imgPath, originWidth, originHeight, layerWidth, layerRate, layerHeight, layerHeightOffset, hamsterWidth, hamsterHeight, hamsterRate, timeCountNum, maxActive, maxCount, init, endCallback;
  useRetina = true;
  getRetinaSize = function(value){
    if (useRetina) {
      return value / 2;
    } else {
      return value;
    }
  };
  imgPath = 'img';
  originWidth = 640;
  originHeight = 960;
  if (useRetina) {
    originWidth = 640 / 2;
    originHeight = 960 / 2;
  }
  layerWidth = Math.min(window.innerWidth, 480);
  layerRate = layerWidth / originWidth;
  layerHeight = parseInt(originHeight * layerRate);
  layerHeightOffset = window.innerHeight - layerHeight;
  layerHeight = Math.min(layerHeight, window.innerHeight);
  layerHeight = Math.max(layerHeight, 400);
  hamsterWidth = 268;
  hamsterHeight = 238;
  if (useRetina) {
    hamsterWidth = 268 / 2;
    hamsterHeight = 238 / 2;
  }
  hamsterRate = hamsterHeight / hamsterWidth;
  timeCountNum = window.playMaxTime || 30;
  maxActive = window.playMaxActive || 2;
  maxCount = window.playMaxCount || 10;
  init = function(){
    var layer, HitCount, hitCount, Hamster, hamster_array, hamster_active, initHamster, letterSpacing, bottomTextHeight, timeLabelText, timeCountNumber, hitLabelText, hitCountNumer, timeCountDownText, timeCountDown, startHamster, endHamster, globalTimer, stopAll, initBrand, initHole;
    if (layerHeightOffset > 0) {
      $('#gameContainer').css('margin-top', layerHeightOffset);
    }
    layer = new collie.Layer({
      width: layerWidth,
      height: layerHeight
    });
    /* hit Text {{{ */
    HitCount = (function(){
      HitCount.displayName = 'HitCount';
      var prototype = HitCount.prototype, constructor = HitCount;
      function HitCount(option){
        var countText;
        countText = new collie.Text({
          width: 140,
          height: 40,
          x: 'right',
          y: 10,
          fontColor: 'red',
          count: 0,
          zIndex: 50,
          visible: false
        }).addTo(option.layer);
        this.handler = countText;
        this._show();
        this;
      }
      prototype._show = function(){
        var countText, count;
        countText = this.handler;
        return count = countText.get('count');
      };
      prototype.add = function(){
        var countText, count;
        countText = this.handler;
        count = countText.get('count');
        countText.set('count', ++count);
        return hitCountNumer.setValue(count);
      };
      prototype.getCount = function(){
        return this.handler.get('count');
      };
      return HitCount;
    }());
    hitCount = new HitCount({
      layer: layer
    });
    /* }}} */
    /* Hamster class {{{ */
    Hamster = (function(){
      Hamster.displayName = 'Hamster';
      var prototype = Hamster.prototype, constructor = Hamster;
      function Hamster(option){
        var hamster, hamster_show, hamster_hit, timer, this$ = this;
        hamster = new collie.DisplayObject({
          x: option.x,
          y: option.y,
          width: hamsterWidth,
          height: hamsterHeight,
          scaleX: layerRate,
          scaleY: layerRate,
          originX: 0,
          originY: 0,
          hitArea: [[0, getRetinaSize(40)], [getRetinaSize(134), getRetinaSize(40)], [getRetinaSize(134), getRetinaSize(236)], [0, getRetinaSize(236)], [0, getRetinaSize(40)]],
          state: 'normal'
        }).addTo(option.layer);
        hamster_show = new collie.DisplayObject({
          x: 0,
          y: 0,
          width: hamsterWidth,
          height: hamsterHeight,
          offsetX: getRetinaSize(300),
          offsetY: getRetinaSize(250),
          backgroundImage: 'hamster',
          visible: false
        }).addTo(hamster);
        hamster_hit = new collie.DisplayObject({
          x: 0,
          y: 0,
          width: hamsterWidth,
          height: hamsterHeight,
          offsetX: getRetinaSize(300),
          offsetY: 0,
          backgroundImage: 'hamster',
          visible: false
        }).addTo(hamster);
        timer = collie.Timer.repeat(function(e){
          this$.hide();
        }, 500, {
          loop: 1,
          beforeDelay: 500
        });
        timer.pause();
        hamster.set('showHandler', hamster_show);
        hamster.set('hitHandler', hamster_hit);
        hamster.set('timer', timer);
        this.handler = hamster;
        this.hash = +new Date();
        this._bindEvent();
        this;
      }
      prototype._bindEvent = function(){
        var hamster, this$ = this;
        hamster = this.handler;
        hamster.attach('click', function(e){
          var state;
          state = hamster.get('state');
          if (state === 'active') {
            hitCount.add();
            this$.hit();
          }
        });
        return this;
      };
      prototype._state = function(state){
        var hamster;
        state == null && (state = false);
        hamster = this.handler;
        if (state) {
          return hamster.set('state', state);
        } else {
          return hamster.get('state');
        }
      };
      prototype.getState = function(){
        return this._state();
      };
      prototype.setState = function(state){
        return this._state(state);
      };
      prototype._operation = function(cmd){
        var hamster, hamster_show, hamster_hit;
        hamster = this.handler;
        hamster_show = hamster.get('showHandler');
        hamster_hit = hamster.get('hitHandler');
        if (cmd === 'show') {
          hamster_show.set('visible', true);
          hamster_hit.set('visible', false);
          this.setState('active');
        } else if (cmd === 'hide') {
          hamster_show.set('visible', false);
          hamster_hit.set('visible', false);
          this.setState('normal');
          _stor('endHamster')(this);
        } else if (cmd === 'hit') {
          hamster_show.set('visible', false);
          hamster_hit.set('visible', true);
          this.setState('hit');
          hamster.get('timer').start();
        }
        return this;
      };
      prototype.show = function(){
        return this._operation('show');
      };
      prototype.hide = function(notForce){
        notForce == null && (notForce = false);
        if (notForce) {
          if (this.getState() === 'active') {
            this._operation('hide');
          }
        } else {
          this._operation('hide');
        }
      };
      prototype.hit = function(){
        var count;
        this._operation('hit');
        count = hitCount.getCount();
        if (count >= maxCount) {
          return endCallback(count, maxCount);
        }
      };
      return Hamster;
    }());
    /* }}} */
    /* init hamster {{{ */
    hamster_array = [];
    hamster_active = [];
    initHamster = function(){
      var position, i$, len$, item, y, hamster, results$ = [];
      position = [
        {
          x: 106,
          y: 242
        }, {
          x: 388,
          y: 242
        }, {
          x: 106,
          y: 502
        }, {
          x: 388,
          y: 502
        }
      ];
      for (i$ = 0, len$ = position.length; i$ < len$; ++i$) {
        item = position[i$];
        y = parseInt(getRetinaSize(item.y) * layerRate);
        if (layerHeightOffset < 0) {
          y += layerHeightOffset;
        }
        hamster = new Hamster({
          x: parseInt(getRetinaSize(item.x) * layerRate),
          y: y,
          layer: layer
        });
        results$.push(hamster_array.push(hamster));
      }
      return results$;
    };
    /* }}} */
    /* info {{{ */
    letterSpacing = -10;
    bottomTextHeight = 32;
    if (useRetina) {
      letterSpacing = 0;
      bottomTextHeight = 24;
    }
    timeLabelText = new collie.DisplayObject({
      x: parseInt(getRetinaSize(40) * layerRate),
      y: 'bottom',
      scaleX: layerRate,
      scaleY: layerRate,
      width: getRetinaSize(100),
      height: bottomTextHeight,
      originX: 0,
      originY: 0,
      offsetX: 0,
      offsetY: getRetinaSize(50),
      backgroundImage: 'countTextImg'
    }).addTo(layer);
    timeCountNumber = new collie.ImageNumber({
      x: parseInt(getRetinaSize(148) * layerRate),
      y: 'bottom',
      width: getRetinaSize(100),
      height: bottomTextHeight,
      letterSpacing: letterSpacing
    }).number({
      width: getRetinaSize(22),
      height: bottomTextHeight,
      scaleX: layerRate,
      scaleY: layerRate,
      originX: 0,
      originY: 0,
      backgroundImage: 'countTextImg'
    }).addTo(layer);
    timeCountNumber.setValue(30);
    hitLabelText = new collie.DisplayObject({
      x: parseInt(getRetinaSize(240) * layerRate),
      y: 'bottom',
      scaleX: layerRate,
      scaleY: layerRate,
      width: getRetinaSize(100),
      height: bottomTextHeight,
      originX: 0,
      originY: 0,
      offsetX: 0,
      offsetY: getRetinaSize(100),
      backgroundImage: 'countTextImg'
    }).addTo(layer);
    hitCountNumer = new collie.ImageNumber({
      x: parseInt(getRetinaSize(348) * layerRate),
      y: 'bottom',
      width: getRetinaSize(100),
      height: bottomTextHeight,
      letterSpacing: letterSpacing
    }).number({
      width: getRetinaSize(22),
      height: bottomTextHeight,
      scaleX: layerRate,
      scaleY: layerRate,
      originX: 0,
      originY: 0,
      backgroundImage: 'countTextImg'
    }).addTo(layer);
    hitCountNumer.setValue(0);
    /* }}} */
    /* time count down {{{ */
    timeCountDownText = new collie.Text({
      width: 80,
      height: 40,
      x: 'right',
      y: 10,
      fontColor: 'red',
      zIndex: 50,
      visible: false
    }).addTo(layer);
    timeCountDownText.text(timeCountNum);
    timeCountDown = collie.Timer.repeat(function(e){
      var text;
      text = timeCountDownText;
      text.text("Time: " + (timeCountNum - e.count));
      timeCountNumber.setValue(timeCountNum - e.count);
      if (timeCountNum - e.count <= 0) {
        e.timer.pause();
        e.timer.stop();
        endCallback(hitCount.getCount(), maxCount);
      }
    }, 1000);
    timeCountDown.pause();
    /* }}} */
    startHamster = function(){
      var hamster_key, hamster;
      if (hamster_active.length < maxActive) {
        hamster_key = Math.floor(Math.random() * hamster_array.length);
        hamster = hamster_array.splice(hamster_key, 1)[0];
        hamster.show();
        hamster_active.push(hamster);
      }
    };
    endHamster = function(hamster){
      var i$, ref$, len$, key, item;
      for (i$ = 0, len$ = (ref$ = hamster_active).length; i$ < len$; ++i$) {
        key = i$;
        item = ref$[i$];
        if (item === hamster) {
          hamster_array.push(hamster_active.splice(key, 1)[0]);
          break;
        }
      }
    };
    _stor('endHamster', endHamster, true);
    globalTimer = collie.Timer.repeat(function(e){
      var rand;
      rand = parseInt(Math.random() * 10);
      if (rand > 5) {
        startHamster();
      }
    }, 500, {
      beforeDelay: 500
    });
    stopAll = function(){
      var hamster;
      globalTimer.stop();
      timeCountDown.stop();
      timeCountNumber.setValue(0);
      while (hamster_active.length) {
        hamster = hamster_active.shift();
        hamster.hide(true);
        hamster_array.push(hamster);
      }
    };
    _stor('stopAll', stopAll, true);
    globalTimer.pause();
    /* initBrand {{{ */
    initBrand = function(){
      var x, y, brand;
      x = parseInt(getRetinaSize(35) * layerRate);
      y = parseInt(getRetinaSize(35) * layerRate);
      brand = new collie.DisplayObject({
        x: parseInt(x * layerRate),
        y: parseInt(y * layerRate),
        scaleX: layerRate,
        scaleY: layerRate,
        width: getRetinaSize(330),
        height: getRetinaSize(360),
        offsetX: getRetinaSize(570),
        offsetY: 0,
        originX: 0,
        originY: 0,
        backgroundImage: 'hamster'
      }).addTo(layer);
    };
    initHole = function(){
      var position, i$, len$, item, y, hole;
      position = [
        {
          x: 55,
          y: 440
        }, {
          x: 340,
          y: 440
        }, {
          x: 55,
          y: 700
        }, {
          x: 340,
          y: 700
        }
      ];
      for (i$ = 0, len$ = position.length; i$ < len$; ++i$) {
        item = position[i$];
        y = parseInt(getRetinaSize(item.y) * layerRate);
        if (layerHeightOffset < 0) {
          y += layerHeightOffset;
        }
        hole = new collie.DisplayObject({
          x: parseInt(getRetinaSize(item.x) * layerRate),
          y: y,
          scaleX: layerRate,
          scaleY: layerRate,
          width: getRetinaSize(300),
          height: getRetinaSize(120),
          offsetX: getRetinaSize(600),
          offsetY: getRetinaSize(380),
          originX: 0,
          originY: 0,
          backgroundImage: 'hamster'
        }).addTo(layer);
      }
    };
    /* }}} */
    collie.Renderer.attach('start', function(){
      initBrand();
      initHole();
      initHamster();
      globalTimer.start();
      timeCountDown.start();
    });
    collie.Renderer.addLayer(layer);
    collie.Renderer.load(document.getElementById('gameContainer'));
    collie.Renderer.start('30fps');
  };
  endCallback = function(count, maxCount){
    _stor('stopAll')();
    if (window.playEndCallback) {
      playEndCallback(count, maxCount);
    }
  };
  collie.Renderer.RETINA_DISPLAY = useRetina;
  collie.ImageManager.add({
    hamster: imgPath + "/bg_hamster.png",
    countTextImg: imgPath + "/bg_count_text.png"
  }, init);
};
imagePreload = (function(){
  imagePreload.displayName = 'imagePreload';
  var prototype = imagePreload.prototype, constructor = imagePreload;
  function imagePreload(imgs, tick, callback){
    if (!imgs.length) {
      return;
    }
    this.tick = tick;
    this.callback = callback;
    this.loadImgArray = [];
    this.imgArray = imgs;
    this.imgCount = imgs.length;
    this.imgLoaded = 0;
    this.init();
    this;
  }
  prototype.init = function(){
    var self, call, i$, ref$, len$, imgUrl, img, results$ = [];
    self = this;
    call = function(){
      self.loadcall(this.getAttribute('imgUrl'));
    };
    for (i$ = 0, len$ = (ref$ = this.imgArray).length; i$ < len$; ++i$) {
      imgUrl = ref$[i$];
      img = new Image(1, 1);
      img.setAttribute('imgUrl', imgUrl);
      img.onload = call;
      results$.push(img.src = imgUrl);
    }
    return results$;
  };
  prototype.loadcall = function(imgUrl){
    var i$, ref$, len$, url;
    for (i$ = 0, len$ = (ref$ = this.imgArray).length; i$ < len$; ++i$) {
      url = ref$[i$];
      if (url === imgUrl) {
        this.imgLoaded += 1;
        if (this.tick) {
          this.tick(imgUrl, this.imgLoaded, this.imgCount);
        }
        if (this.imgLoaded === this.imgCount && this.callback) {
          this.callback();
        }
        break;
      }
    }
  };
  return imagePreload;
}());
imagePreload.load = function(imgs, tick, callback){
  return new imagePreload(imgs, tick, callback);
};
/* vim: se sw=2 ts=2 sts=2 fdm=marker et: */