{ |window, action|
  var rate = Slider.new(window, Point(window.bounds.width, window.bounds.height));
  rate.orientation = \vertical;
  rate.resize = 5;
  rate.action = { |obj| action.value(obj.value.linlin(0, 1, -2, 2)) };
  (
    setRate: { |self, newRate|
      { rate.value = newRate }.defer
    }
  )
}
