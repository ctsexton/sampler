{ |config, store|
  var gridState = ();
  var endpoint = MIDIIn.findPort(config.lpDeviceName, config.lpPortName);
  var launchpad = Launchpad.new(endpoint);

  var shift = false;

  var setAllColors = { |color|
    gridState.keysValuesDo({|key, value|
      if (value !== color, {
        var x = key.mod(8);
        var y = key.div(8);
        launchpad.lightGrid(x, y, color);
      })
    })
  };

  var storeActions = [
    { |msg|
      if (gridState.includesKey(msg.nn), {
        store.restore(msg.nn);
        setAllColors.value(\yellow);
        launchpad.lightGrid(msg.x, msg.y, \green);
        gridState[msg.nn] = \green;
      })
    },
    { |msg|
      store.save(msg.nn);
      setAllColors.value(\yellow);
      launchpad.lightGrid(msg.x, msg.y, \red);
      gridState[msg.nn] = \red;
    }
  ];

  launchpad.gridResponder = { |msg|
    if (msg.vel === 1, {
      storeActions[shift.asInteger].value(msg);
    })
  };

  launchpad.topResponder = { |msg|
    if (msg.index === 0, {
      shift = msg.vel.asBoolean;
      launchpad.ledset(\top, msg.index, [\green, \red][msg.vel]);
    })
  };

  launchpad.clear();
}
