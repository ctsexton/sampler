var createState = "./state.scd".loadRelative[0];
var createStore = "./store.scd".loadRelative[0];
var createEventBroker = "./eventBroker.scd".loadRelative[0];
var setupMidiDevices = "./setupMidiDevices.scd".loadRelative[0];
var ui = "./ui.scd".loadRelative[0];

var main = { |config|
  var topics = [\track, \master];
  var eventBroker = createEventBroker.value(topics);
  var state = createState.value(3);
  var store = createStore.value(state, eventBroker);
  if (config["enableMIDI"] == "true", {
    setupMidiDevices.value(config, store, eventBroker);
  });
  eventBroker.subscribe([\track, \master], ui);
  store.initialize;
};

s.waitForBoot({ 
  var configFilePath = "../config.yml".resolveRelative();
  var config = configFilePath.parseYAMLFile();
  main.value(config);
})
