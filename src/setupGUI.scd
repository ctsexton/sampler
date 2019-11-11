var createFilterGUI = "./gui/filter.scd".loadRelative[0];
{ |config, sampler, eventBroker|
  var ui;
  var filterGUIs;
  var bounds = Rect(100, 700, 800, 800);
  var window = Window("filt", bounds);
  var views = { View.new() } ! 3;
  var notifications;
  window.layout = VLayout(*views);
  filterGUIs = 3.collect({ |i|
    var filterAction = { |cutoff, resonance|
      sampler.setTrackParameter(i, \lpfCutoff, cutoff);
      sampler.setTrackParameter(i, \lpfResonance, resonance);
    };
    createFilterGUI.value(views[i], filterAction);
  });

  window.front;
  notifications = (
    lpfCutoff: { |msg| filterGUIs[msg.index].setCutoff(msg.normalized) },
    lpfResonance: { |msg| filterGUIs[msg.index].setResonance(msg.normalized) }
  );
  ui = (
    notify: { |self, msg|
      if (msg.topic == \track && notifications.includesKey(msg.param), {
        notifications[msg.param].value(msg);
      })
    }
  );
  eventBroker.subscribe([\track, \master], ui);
}
