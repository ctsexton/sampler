var createState = "./state.scd".loadRelative[0];
var createStore = "./store.scd".loadRelative[0];
var createEventBroker = "./eventBroker.scd".loadRelative[0];
var setupMidiDevices = "./setupMidiDevices.scd".loadRelative[0];
var ui = "./ui.scd".loadRelative[0];
var synthDefs = ["./synthdefs/sampler.scd".loadRelative[0]];
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
  synths = Array.fill(3, { |i|
    Synth.new(\windowLooper, [
      \buffer, samples[0].buffer,
      \rate, 1,
      \window, 1,
      \offset, 0,
      \playhead, state.tracks[i].playhead.bus,
      \lpfCutoff, 1,
      \hpfCutoff, 0,
      \status, 0,
      \output, 0,
      \volume, 1
    ])});
  synths.do({ |item, i| item.map(
    \offset, state.tracks[i].offset.bus,
    \window, state.tracks[i].window.bus,
    \rate, state.tracks[i].rate.bus,
    \volume, state.tracks[i].volume.bus
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
