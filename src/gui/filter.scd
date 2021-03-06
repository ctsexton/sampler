{ |window, preFilterBus, postFilterBus, action, freqscopeActive|
  var cutoff = 1;
  var resonance = 0.5;
  var q = 0;
  var clicked = false;
  var relativeWhere;
  var v = UserView(window, Rect(0, 0, window.bounds.width, window.bounds.height));
  var cutoffWidthBound = window.bounds.width - 40;
  var cutoffLeftBound = 20;
  var cutoffRightBound = window.bounds.width - 20;
  var freqscope = FreqScopeView.response(parent: window, bounds: Point(v.bounds.width, v.bounds.height), bus1: preFilterBus, bus2: postFilterBus);
  var radius = 7;
  var grabber = Rect(cutoffLeftBound + cutoffWidthBound * cutoff, (v.bounds.height * (1 - resonance)) - radius, radius * 2, radius * 2);
  var lpfSlope = 1.25;

  var drawGrabber = { |grabber|
    Pen.addOval(grabber);
    Pen.fill;
  };

  var drawLPFSlope = { |grabber, bounds|
    var endPoint = Point(grabber.center.x + (lpfSlope * (bounds.height - grabber.center.y)), v.bounds.height);
    var ctrlX = grabber.center.x + ((endPoint.x - grabber.center.x) * 0.35);
    var ctrlY = grabber.center.y + ((endPoint.y - grabber.center.y) * 0.7);
    var ctrlPoint = Point(ctrlX, ctrlY);
    Pen.moveTo(grabber.center);
    Pen.quadCurveTo(endPoint, ctrlPoint);
    Pen.stroke;
  };

  var drawResonancePeak = { |grabber, bounds|
    Pen.moveTo(Point(bounds.left + (q * grabber.center.x),  bounds.height / 2));
    Pen.quadCurveTo(grabber.center, Point(grabber.center.x / 2, bounds.height / 2));
    Pen.stroke;
  };

  var setGrabber = { |v, x, y|
    grabber.origin = Point(x, y);
    cutoff = x / cutoffWidthBound;
    resonance = 1 - (y / v.bounds.height);
    action.value(cutoff, resonance);
    window.refresh;
  };

  v.onResize = { |newView|
    var cutoffWidthBound = newView.bounds.width - 40;
    grabber.left = newView.bounds.left + cutoffWidthBound * cutoff;
    grabber.top = (newView.bounds.height * (1 - resonance)) - radius;
  };

  v.drawFunc = {
    Pen.strokeColor = Color.red;
    Pen.fillColor = Color.red;
    drawGrabber.value(grabber);
    drawResonancePeak.value(grabber, v.bounds);
    drawLPFSlope.value(grabber, v.bounds);
  };

  v.mouseDownAction = { |v, x, y|
    clicked = true;
    setGrabber.value(v, x, y);
  };

  v.mouseMoveAction = { |v, x, y|
    if (clicked, {
      setGrabber.value(v, x, y);
    });
  };

  v.mouseUpAction = { clicked = false };
  v.resize = 5;
  v.front;
  freqscope.freqMode = 1;
  if (freqscopeActive == "true", { freqscope.active = true });
  freqscope.resize = 5;
  window.onClose_({ freqscope.kill });
  (
    setCutoff: { |self, newCutoff|
      if (clicked == false, {
        cutoff = newCutoff;
        {
          grabber.left = cutoffLeftBound + cutoffWidthBound * cutoff - radius;
          window.refresh;
        }.defer;
      })
    },
    setResonance: { |self, newResonance|
      if (clicked == false, {
        resonance = newResonance;
        {
          grabber.top = (v.bounds.height * (1 - resonance)) - radius;
          window.refresh;
        }.defer;
      })
    }
  )
}
