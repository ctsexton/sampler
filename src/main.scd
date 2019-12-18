var createConfig = "./config.scd".loadRelative[0];
var createState = "./state.scd".loadRelative[0];
var createStore = "./store.scd".loadRelative[0];
var createEventBroker = "./eventBroker.scd".loadRelative[0];
var setupMidiDevices = "./setupMidiDevices.scd".loadRelative[0];
var setupGUI = "./setupGUI.scd".loadRelative[0];
var setupDebugUI = "./debugUI.scd".loadRelative[0];
var synthDefs = ["./synthdefs/sampler.scd".loadRelative[0]];
var getSamples = "./samples.scd".loadRelative[0];
var createSynth = "./synth.scd".loadRelative[0];
var createBusses = "./busses.scd".loadRelative[0];
var setupOSC = "./osc.scd".loadRelative[0];

var main = { |config|
  var synth;
  var topics = [\track, \master];
  var eventBroker = createEventBroker.value(topics);
  var state = createState.value(config.numTracks);
  var defaults = createState.value(config.numTracks);
  var busses = createBusses.value(state);
  var samples = getSamples.value(config);
  var store = createStore.value(state, defaults, busses, eventBroker, samples);
  if (config.enableMIDI, {
    setupMidiDevices.value(config, store, eventBroker);
  });
  if (config.enableGUI, {
    setupGUI.value(config, store, eventBroker, busses);
  });
  if (config.enableDebug, {
    setupDebugUI.value(eventBroker);
  });
  setupOSC.value(config, store, eventBroker);
  store.initialize;
  synth = createSynth.value(config, samples, state, busses);
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
