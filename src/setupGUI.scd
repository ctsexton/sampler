var createTrackGUI = "./gui/track.scd".loadRelative[0];

{ |config, sampler, eventBroker, busses|
  var ui, tracks;
  var bounds = Rect(100, 700, 1600, 800);
  var parentWindow = Window("bITMangler9000", bounds);
  var notifications;
  var trackViews = { View.new() } ! config.numTracks;

  parentWindow.layout = VLayout(*trackViews);
  parentWindow.front;

  tracks = config.numTracks.collect{ |i|
    createTrackGUI.value(config, trackViews[i], sampler, busses.tracks[i], i);
  };

  notifications = (
    lpfCutoff: { |msg| tracks[msg.index].filter.setCutoff(msg.normalized) },
    lpfResonance: { |msg| tracks[msg.index].filter.setResonance(msg.normalized) },
    offset: { |msg| tracks[msg.index].looper.setOffset(msg.normalized) },
    window: { |msg| tracks[msg.index].looper.setWindow(msg.normalized) },
    sampleIndex: { |msg| tracks[msg.index].looper.setSoundfile(msg.soundfile) }
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
