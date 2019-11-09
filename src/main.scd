var createState = "./state.scd".loadRelative[0];
var createStore = "./store.scd".loadRelative[0];
var createEventBroker = "./eventBroker.scd".loadRelative[0];
var setupMidiDevices = "./setupMidiDevices.scd".loadRelative[0];
var ui = "./ui.scd".loadRelative[0];
var synthDefs = ["./synthdefs/test.scd".loadRelative[0]];
var getSamples = "./samples.scd".loadRelative[0];

var main = { |config|
  var topics = [\track, \master];
  var eventBroker = createEventBroker.value(topics);
  var state = createState.value(3);
  var store = createStore.value(state, eventBroker);
  var synths;
  var samples = getSamples.value(config);
  if (config["enableMIDI"] == "true", {
    setupMidiDevices.value(config, store, eventBroker);
  });
  eventBroker.subscribe([\track, \master], ui);
  store.initialize;
  synths = Array.fill(3, {
    Synth.new(\test, [
      \volume, 1,
      \pitch, 0.5,
      \cutoff, 1
    ])});
  synths.do({ |item, i| item.map(
    \volume, state.tracks[i].volume.bus,
    \pitch, state.tracks[i].offset.bus,
    \cutoff, state.tracks[i].window.bus
  )});
};

s.waitForBoot({ 
  var configFilePath = "../config.yml".resolveRelative();
  var config = configFilePath.parseYAMLFile();
  ServerMeter.new(s, 2, 2);
  Routine({
    synthDefs.do({ |def| def.add; });
    s.sync;
    main.value(config);
  }).play;
})
