var createFilterGUI = "./gui/filter.scd".loadRelative[0];
{ |config, sampler, eventBroker|
  var ui;
  var filterGUIs;
  var bounds = Rect(100, 700, 800, 800);
  var window = Window("filt", bounds);
  var views = { View.new() } ! 3;
  window.layout = VLayout(*views);
  filterGUIs = 3.collect({ |i|
    var filterAction = { |cutoff, resonance|
      sampler.setTrackParameter(i, \lpfCutoff, cutoff);
      sampler.setTrackParameter(i, \lpfResonance, resonance);
    };
    createFilterGUI.value(views[i], filterAction);
  });

  window.front;
  ui = (
    notify: { |self, msg|
      if (msg.topic == \track, {
        if (msg.param == \lpfCutoff, {
          filterGUIs[msg.index].setCutoff(msg.normalized);
        });
      })
    }
  );
  eventBroker.subscribe([\track, \master], ui);
}
