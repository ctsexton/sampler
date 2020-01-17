{ |window, samples, action|
  var items = samples.collect({ |sample, i|
    sample.name -> action.value(i)
  });
  EZPopUpMenu.new(window,
    Point(window.bounds.width, window.bounds.height),
    nil,
    items,
    initVal: 0);
}
