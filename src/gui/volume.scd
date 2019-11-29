{ |window, action, levelsOscAddr|
  var meters = { |i|
    var width = window.bounds.width * 0.5;
    var m = LevelIndicator(window, Rect(i * width, 0, width, window.bounds.height));
    m.style = \led;
    m.stepWidth = 3;
    m
  } ! 2;

  var detectLevels = OSCFunc({ |msg|
    {
      meters.do({ |m, i| 
        m.value = msg[3].rms[i].ampdb.linlin(-40, 0, 0, 1);
        m.peakLevel = msg[3].peak[i].ampdb.linlin(-40, 0, 0, 1);
      });
    }.defer;
  }, levelsOscAddr, s.addr);

  var ledWidth = (window.bounds.width * 0.125).asInteger;
  var slider = Slider(window, Rect(ledWidth, 0, window.bounds.width - (2 * ledWidth), window.bounds.height));
  slider.focusColor = Color.clear;
  slider.background = Color.grey;
  slider.thumbSize = 15;
  slider.value = 0;
  slider.action = { |obj|
    action.value(obj.value);
  }
}
