{ |window, samples, action|
  var items = samples.collect({ |sample, i|
    sample.name -> action.value(i)
  });
  var ui = EZPopUpMenu.new(window,
    Point(window.bounds.width, window.bounds.height),
    nil,
    items,
    initVal: 0);
  (
    setSampleIndex: { |self, index|
      { ui.value = index }.defer;
    }
  )
}
