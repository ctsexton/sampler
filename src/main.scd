var main = {
  var configFilePath = "../config.yml".resolveRelative();
  var createState = "./state.scd".loadRelative[0];
  var createStore = "./store.scd".loadRelative[0];
  var createEventBroker = "./eventBroker.scd".loadRelative[0];
  var topics = [\track, \master];
  var eventBroker = createEventBroker.value(topics);
  var ui = "./ui.scd".loadRelative[0];
  var state = createState.value(4);
  var store = createStore.value(state, eventBroker);

  eventBroker.subscribe(\track, ui);

  store.setTrackRate(0, 0.5);
  store.setTrackVolume(1, 1.5);
  store.setTrackWindow(1, 0.5);
  store.setMasterWindow(0.5);
  store.setMasterVolume(1.5);
}

/* { */
/* 	|configFile| */
/* 	var config = configFile.parseYAMLFile(); */
/* 	config["morphAddr"].postln; */
/* 	config; */
/* }.value(configFilePath); */


s.waitForBoot({ 
  MIDIClient.init; 
  main.value();
})
