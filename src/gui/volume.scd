{ |window, action, levelsOscAddr|
  var meters = { |i|
    var width = window.bounds.width * 0.5;
    var m = LevelIndicator(window, Rect(i * width, 0, width, window.bounds.height));
    m.style = \led;
    m.stepWidth = 3;
    m.drawsPeak = true;
    m
  } ! 2;

  var ledWidth = (window.bounds.width * 0.125).asInteger;
  var slider = Slider(window, Rect(ledWidth, 0, window.bounds.width - (2 * ledWidth), window.bounds.height));
  slider.focusColor = Color.clear;
  slider.background = Color.grey;
  slider.thumbSize = 15;
  slider.value = 0;
  slider.action = { |obj|
    action.value(obj.value);
  };
  slider.orientation = \vertical;

  OSCFunc.new({ |msg|
    {
      meters.do({ |m, i| 
        m.peakLevel = msg[i * 2 + 3].ampdb.linlin(-40, 0, 0, 1);
        m.value = msg[i * 2 + 4].ampdb.linlin(-40, 0, 0, 1);
      });
    }.defer;
  }, levelsOscAddr, s.addr);

  (
    setVolume: { |self, newVolume|
      slider.value = newVolume;
    }
  )
}
