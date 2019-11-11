{ |window, action|
  var cutoff = 0.75;
  var resonance = 0.5;
  var q = 0;
  var clicked = false;
  var relativeWhere;
  var v = UserView(window, Rect(0, 0, window.bounds.width, window.bounds.height));
  var radius = 7;
  var grabber = Rect(v.bounds.left + v.bounds.width * cutoff, (v.bounds.height * (1 - resonance)) - radius, radius * 2, radius * 2);
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

  v.onResize = { |newView|
    grabber.left = newView.bounds.left + newView.bounds.width * cutoff;
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
    if (grabber.contains(Point(x, y)), {
      clicked = true;
      relativeWhere = Point(x, y) - grabber.origin;
    });
  };

  v.mouseMoveAction = { |v, x, y|
    if (clicked, {
      grabber.origin = Point(x, y) - relativeWhere;
      cutoff = x / v.bounds.width;
      resonance = 1 - (y / v.bounds.height);
      action.value(cutoff, resonance);
      window.refresh;
    });
  };

  v.mouseUpAction = { clicked = false };
  v.resize = 5;
  (
    setCutoff: { |self, newCutoff|
      if (clicked == false, {
        cutoff = newCutoff;
        {
          grabber.left = v.bounds.left + v.bounds.width * cutoff;
          grabber.top = (v.bounds.height * (1 - resonance)) - radius;
          window.refresh;
        }.defer;
      })
    },
    setResonance: { |self, newResonance|
      if (clicked == false, {
        resonance = newResonance;
        {
          grabber.left = v.bounds.left + v.bounds.width * cutoff;
          grabber.top = (v.bounds.height * (1 - resonance)) - radius;
          window.refresh;
        }.defer;
      })
    }
  )
}
