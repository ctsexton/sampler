var createFilterGUI = "./gui/filter.scd".loadRelative[0];
{ |config, sampler, eventBroker|
  var ui;
  var bounds = Rect(100, 700, 800, 400);
  var window = Window("filt", bounds);
  var filterAction = { |cutoff, resonance|
    sampler.setTrackParameter(0, \lpfCutoff, cutoff);
  };
  var filterGUI = createFilterGUI.value(window, filterAction);

  window.front;
  ui = (
    notify: { |self, msg|
      if (msg.topic == \track, {
        "GUI received a message!".postln;
        if (msg.param == \lpfCutoff && msg.index == 0, {
          filterGUI.setCutoff(msg.normalized);
        });
        msg.postln;
      })
    }
  );
  eventBroker.subscribe([\track, \master], ui);
}
