var createState = "./state.scd".loadRelative[0];
var createStore = "./store.scd".loadRelative[0];
var createEventBroker = "./eventBroker.scd".loadRelative[0];
var setupMidiDevices = "./setupMidiDevices.scd".loadRelative[0];
var ui = "./ui.scd".loadRelative[0];
var synthDefs = ["./synthdefs/test.scd".loadRelative[0]];

var main = { |config|
  var topics = [\track, \master];
  var eventBroker = createEventBroker.value(topics);
  var state = createState.value(3);
  var store = createStore.value(state, eventBroker);
  var synth;
  if (config["enableMIDI"] == "true", {
    setupMidiDevices.value(config, store, eventBroker);
  });
  eventBroker.subscribe([\track, \master], ui);
  store.initialize;
  synth = Synth.new(\test, [\volume, 1, \pitch, 0.5]);
  synth.map(\volume, state.tracks[0].volume.bus, \pitch, state.tracks[0].offset.bus);
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
