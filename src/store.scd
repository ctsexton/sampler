{ |state, eventBroker|
  var setTrackClippedParameter = { |trackIndex, param, val, lo, hi|
    var clippedValue = val.clip(lo, hi);
    var normalizedValue = clippedValue.linlin(lo, hi, 0, 1);
    state.tracks[trackIndex][param].val = clippedValue;
    state.tracks[trackIndex][param].bus.set(clippedValue);
    eventBroker.publish((
      topic: \track,
      index: trackIndex,
      param: param,
      val: state.tracks[trackIndex][param].val,
      normalized: normalizedValue
    ))
  };
  var setMasterClippedParameter = { |param, val, lo, hi|
    var clippedValue = val.clip(lo, hi);
    var normalizedValue = clippedValue.linlin(lo, hi, 0, 1);
    state.master[param].val = clippedValue;
    state.master[param].bus.set(clippedValue);
    eventBroker.publish((
      topic: \master,
      param: param,
      val: state.master[param].val,
      normalized: normalizedValue
    ))
  };
  (
    setTrackOffset: { |self, trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \offset, val, 0, 1)
    },
    setTrackWindow: { |self, trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \window, val, 0, 1)
    },
    setTrackRate: { |self, trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \rate, val, -2, 2)
    },
    setTrackLpfCutoff: { |self, trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \lpfCutoff, val, 0, 1)
    },
    setTrackHpfCutoff: { |self, trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \hpfCutoff, val, 0, 1)
    },
    setTrackVolume: { |self, trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \volume, val, 0, 1)
    },
    setTrackSampleIndex: { |self, trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \sampleIndex, val, 0, 10)
    },
    setMasterReverb: { |self, val|
      setMasterClippedParameter.value(\reverb, val, 0, 1)
    },
    setMasterDistortion: { |self, val|
      setMasterClippedParameter.value(\distortion, val, 0, 1)
    },
    setMasterLpfCutoff: { |self, val|
      setMasterClippedParameter.value(\lpfCutoff, val, 0, 1)
    },
    setMasterHpfCutoff: { |self, val|
      setMasterClippedParameter.value(\hpfCutoff, val, 0, 1)
    },
    setMasterVolume: { |self, val|
      setMasterClippedParameter.value(\volume, val, 0, 1)
    },
  )
}
