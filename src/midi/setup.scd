var createAddress = "../util/createAddress.scd".loadRelative[0];
var createPresetController = "./gridPresets.scd".loadRelative[0];
var createMFT = "./mft.scd".loadRelative[0];

{ |config, controller, eventRouter, store|
  MIDIClient.init;
  MIDIIn.connectAll;

  createMFT.value(config, controller, eventRouter);
  createPresetController.value(config, store);
}
