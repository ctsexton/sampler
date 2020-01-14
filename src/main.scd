var createConfig = "./config.scd".loadRelative[0];
var createEventBroker = "./eventRouter.scd".loadRelative[0];
var setupMidiDevices = "./setupMidiDevices.scd".loadRelative[0];
var setupGUI = "./setupGUI.scd".loadRelative[0];
var setupDebugUI = "./debugUI.scd".loadRelative[0];
var synthDefs = ["./synthdefs/sampler.scd".loadRelative[0]];
var getSamples = "./samples.scd".loadRelative[0];
var createSynth = "./synth.scd".loadRelative[0];
var setupOSC = "./osc.scd".loadRelative[0];
var createParameters = "./parameters.scd".loadRelative[0];
var createController = "./core/controller.scd".loadRelative[0];

var main = { |config|
  var synth;
  var eventRouter = createEventBroker.value();
  var samples = getSamples.value(config);
  var parameterTree = createParameters.value(config.numTracks);
  var controller = createController.value(parameterTree, eventRouter);
  eventRouter.addAddresses(controller.listParameters());
  /* if (config.enableMIDI, { */
  /*   setupMidiDevices.value(config, store, eventRouter); */
  /* }); */
  /* if (config.enableGUI, { */
  /*   setupGUI.value(config, controller, eventRouter); */
  /* }); */
  if (config.enableDebug, {
    setupDebugUI.value(eventRouter);
  });
  setupOSC.value(config, controller, eventRouter);
  synth = createSynth.value(config, samples, controller);
  synth.start;
};

s.waitForBoot({ 
  var configFilePath = "../config.yml".resolveRelative();
  var config = createConfig.value(configFilePath);
  ServerMeter.new(s, 2, 2);
  Routine({
    synthDefs.do({ |def| def.add; });
    s.sync;
    main.value(config);
  }).play(AppClock);
})
