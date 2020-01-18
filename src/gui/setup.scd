var createTrackGUI = "./track.scd".loadRelative[0];
var createAddress = "../util/createAddress.scd".loadRelative[0];

{ |config, controller, eventRouter, samples|
  var ui, tracks;
  var bounds = Rect(100, 700, 1600, 800);
  var parentWindow = Window("Dishing Wachine", bounds);
  var notifications;
  var trackViews = { View.new() } ! config.numTracks;
  var subscribe = { |addressAsArray, action|
    var address = createAddress.value(addressAsArray);
    var ui = (
      notify: { |self, msg| action.value(msg) }
    );
    eventRouter.subscribe([address], ui)
  };

  parentWindow.layout = VLayout(*trackViews);
  parentWindow.front;

  tracks = config.numTracks.collect{ |i|
    var track = createTrackGUI.value(config, trackViews[i], controller, i, samples);
    subscribe.value(['sampler', i, 'rate'], { |msg| track.rate.setRate(msg.normalized) });
    subscribe.value(['sampler', i, 'lpf', 'cutoff'], { |msg| track.filter.setCutoff(msg.normalized) });
    subscribe.value(['sampler', i, 'lpf', 'resonance'], { |msg| track.filter.setResonance(msg.normalized) });
    subscribe.value(['sampler', i, 'offset'], { |msg| track.looper.setOffset(msg.normalized) });
    subscribe.value(['sampler', i, 'window'], { |msg| track.looper.setWindow(msg.normalized) });
    subscribe.value(['sampler', i, 'sampleIndex'], { |msg| track.looper.setSoundfile(samples[msg.val].soundfile) });
    subscribe.value(['sampler', i, 'sampleIndex'], { |msg| track.sampleSelector.setSampleIndex(msg.val) });
    subscribe.value(['sampler', i, 'volume'], { |msg| track.volume.setVolume(msg.normalized) });
    track;
  };
}
