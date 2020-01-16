{ |store|
  var presets = ();
  var launchpad = Launchpad.new();

  var shift = false;

  var storeActions = [
    { |key| store.restore(key) },
    { |key| store.save(key) }
  ];

  launchpad.gridResponderFunction = { |section, position, vel|
    if (section === \top, {
      shift = vel.asBoolean;
      launchpad.ledset(\top, position, [\red, \green][vel]);
    });
    if (section === \grid, {
      storeActions[shift.asInteger].value(position[0]);
    });
  }
}
