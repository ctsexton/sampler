{ |config, store|
  var gridState = ();
  var endpoint = MIDIIn.findPort(config.lpDeviceName, config.lpPortName);
  var launchpad = Launchpad.new(endpoint);

  var shift = false;

  var setAllColors = { |color|
    gridState.keysValuesDo({|key, value|
      if (value !== color, {
        launchpad.lightGrid(key.x, key.y, color)
      })
    })
  };

  var storeActions = [
    { |msg|
      store.restore(msg.nn);
      setAllColors.value(\yellow);
      launchpad.lightGrid(msg.x, msg.y, \green);
      gridState[msg] = \green;
    },
    { |msg|
      store.save(msg.nn);
      setAllColors.value(\yellow);
      launchpad.lightGrid(msg.x, msg.y, \red);
      gridState[msg] = \red;
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
}
