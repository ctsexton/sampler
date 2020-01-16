{ |config, store|
  var presets = ();
  var endpoint = MIDIIn.findPort(config.lpDeviceName, config.lpPortName);
  var launchpad = Launchpad.new(endpoint);

  var shift = false;

  var storeActions = [
    { |key| store.restore(key) },
    { |key| store.save(key) }
  ];

  launchpad.gridResponderFunction = { |msg|
    if (msg.section === \top, {
      shift = msg.vel.asBoolean;
      launchpad.ledset(\top, msg.index, [\red, \green][msg.vel]);
    });
    if (msg.section === \grid, {
      storeActions[shift.asInteger].value(msg.nn);
    });
  }
}
