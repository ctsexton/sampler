var createFilterGUI = "./filter.scd".loadRelative[0];
var createLooperGUI = "./looper.scd".loadRelative[0];
var createVolumeGUI = "./volume.scd".loadRelative[0];
var createRateGUI = "./rate.scd".loadRelative[0];

{
  |config, window, sampler, busses, trackIndex|
  var rate, rateAction, filter, filterAction, looper, looperAction, volume, volumeAction;
  var i = trackIndex;
  var rateView = View.new().maxWidth_(50);
  var filterView = View.new();
  var looperView = View.new();
  var volumeView = View.new().maxWidth_(40);
  window.layout = HLayout(rateView, filterView, looperView, volumeView);

  rateAction = { |rate|
    sampler.setTrackParameter(i, \rate, rate);
  };
  rate = createRateGUI.value(rateView, rateAction);

  filterAction = { |cutoff, resonance|
    sampler.setTrackParameter(i, \lpfCutoff, cutoff);
    sampler.setTrackParameter(i, \lpfResonance, resonance);
  };
  filter = createFilterGUI.value(filterView, busses.prefilter, busses.output, filterAction, config.freqscopeActive);

  looperAction = { |offset, window|
    sampler.setTrackParameter(i, \offset, offset);
    sampler.setTrackParameter(i, \window, window);
  };
  looper = createLooperGUI.value(looperView, \track_playhead_ ++ i, looperAction);

  volumeAction = { |volume|
    sampler.setTrackParameter(i, \volume, volume);
  };
  volume = createVolumeGUI.value(volumeView, volumeAction, \track_level_ ++ i);

  looper.startAnimation;

  (
    rate: rate,
    filter: filter,
    looper: looper,
    volume: volume
  )
}
