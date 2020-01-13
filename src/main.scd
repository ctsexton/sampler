var createConfig = "./config.scd".loadRelative[0];
var createEventBroker = "./eventBroker.scd".loadRelative[0];
var setupMidiDevices = "./setupMidiDevices.scd".loadRelative[0];
var setupGUI = "./setupGUI.scd".loadRelative[0];
var setupDebugUI = "./debugUI.scd".loadRelative[0];
var synthDefs = ["./synthdefs/sampler.scd".loadRelative[0]];
var getSamples = "./samples.scd".loadRelative[0];
var createSynth = "./synth.scd".loadRelative[0];
var setupOSC = "./osc.scd".loadRelative[0];
var createParameters = "./parameters.scd".loadRelative[0];
var createController = "./controller/router.scd".loadRelative[0];

var main = { |config|
  var synth;
  var eventBroker = createEventBroker.value();
  var samples = getSamples.value(config);
  var parameters = createParameters.value(config.numTracks);
  var controller = createController.value(parameters, eventBroker);
  eventBroker.addTopics(controller.listParameters());
  /* if (config.enableMIDI, { */
  /*   setupMidiDevices.value(config, store, eventBroker); */
  /* }); */
  /* if (config.enableGUI, { */
  /*   setupGUI.value(config, store, eventBroker, busses); */
  /* }); */
  if (config.enableDebug, {
    setupDebugUI.value(eventBroker);
  });
  setupOSC.value(config, controller, eventBroker);
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
