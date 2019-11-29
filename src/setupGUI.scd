var createFilterGUI = "./gui/filter.scd".loadRelative[0];
var createLooperGUI = "./gui/looper.scd".loadRelative[0];
var createVolumeGUI = "./gui/volume.scd".loadRelative[0];

{ |config, sampler, eventBroker, busses|
  var ui;
  var filterGUIs, looperGUIs, volumeGUIs;
  var freqscope;
  var bounds = Rect(100, 700, 1600, 800);
  var parentWindow = Window("bITMangler9000", bounds);
  var filterViews = { View.new() } ! 3;
  var looperViews = { View.new() } ! 3;
  var volumeViews = { View.new().maxWidth_(40) } ! 3;
  var notifications;

  parentWindow.layout = HLayout(VLayout(*filterViews), VLayout(*looperViews), VLayout(*volumeViews));

  filterGUIs = 3.collect({ |i|
    var filterAction = { |cutoff, resonance|
      sampler.setTrackParameter(i, \lpfCutoff, cutoff);
      sampler.setTrackParameter(i, \lpfResonance, resonance);
    };
    createFilterGUI.value(filterViews[i], busses.tracks[i].prefilter, busses.tracks[i].output, filterAction, config["freqscopeActive"]);
  });
  looperGUIs = 3.collect({ |i|
    var action = { |offset, window|
      sampler.setTrackParameter(i, \offset, offset);
      sampler.setTrackParameter(i, \window, window);
    };
    createLooperGUI.value(looperViews[i], \track_playhead_ ++ i, action);
  });
  volumeGUIs = 3.collect({ |i|
    var action = { |volume|
      sampler.setTrackParameter(i, \volume, volume);
    };
    createVolumeGUI.value(volumeViews[i], action, \track_level_ ++ i);
  });
  
  looperGUIs.do({ |item| item.startAnimation });

  parentWindow.front;
  notifications = (
    lpfCutoff: { |msg| filterGUIs[msg.index].setCutoff(msg.normalized) },
    lpfResonance: { |msg| filterGUIs[msg.index].setResonance(msg.normalized) },
    offset: { |msg| looperGUIs[msg.index].setOffset(msg.normalized) },
    window: { |msg| looperGUIs[msg.index].setWindow(msg.normalized) },
    sampleIndex: { |msg| looperGUIs[msg.index].setSoundfile(msg.soundfile) }
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
