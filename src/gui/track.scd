var createFilterGUI = "./filter.scd".loadRelative[0];
var createLooperGUI = "./looper.scd".loadRelative[0];
var createVolumeGUI = "./volume.scd".loadRelative[0];
var createRateGUI = "./rate.scd".loadRelative[0];
var createAddress = "../util/createAddress.scd".loadRelative[0];

{
  |config, window, controller, trackIndex|
  var rate, rateAction, filter, filterAction, looper, looperAction, volume, volumeAction;
  var i = trackIndex;
  var rateView = View.new().maxWidth_(50);
  var filterView = View.new();
  var looperView = View.new();
  var volumeView = View.new().maxWidth_(40);
  window.layout = HLayout(rateView, looperView, filterView, volumeView);

  rateAction = { |address|
    { |rate|
      controller.setParameter(address, rate);
    }
  };
  rate = createRateGUI.value(rateView, rateAction.value(createAddress.value(['sampler', trackIndex, 'rate'])));

  filterAction = { |cutoffAddress, resonanceAddress|
    { |cutoff, resonance|
      controller.setParameter(cutoffAddress, cutoff);
      controller.setParameter(resonanceAddress, resonance);
    }
  };
  filter = createFilterGUI.value(
    filterView,
    Bus.audio(),
    Bus.audio(),
    filterAction.value(createAddress.value(['sampler', trackIndex, 'lpf', 'cutoff']), createAddress.value(['sampler', trackIndex, 'lpf', 'resonance'])),
    config.freqscopeActive
  );

  looperAction = { |offsetAddress, windowAddress|
    { |offset, window|
      controller.setParameter(offsetAddress, offset);
      controller.setParameter(windowAddress, window);
    }
  };
  looper = createLooperGUI.value(
    looperView,
    \track_playhead_ ++ i,
    looperAction.value(createAddress.value(['sampler', trackIndex, 'offset']), createAddress.value(['sampler', trackIndex, 'window']))
  );

  volumeAction = { |address|
    { |volume|
      controller.setParameter(address, volume);
    }
  };
  volume = createVolumeGUI.value(volumeView, volumeAction.value(createAddress.value(['sampler', trackIndex, 'volume'])), \track_level_ ++ i);

  looper.startAnimation;

  (
    rate: rate,
    filter: filter,
    looper: looper,
    volume: volume
  )
}
