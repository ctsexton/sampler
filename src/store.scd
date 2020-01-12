{ |state, defaults, busses, eventBroker, samples|
  var setTrackClippedParameter = { |trackIndex, param, val, lo, hi|
    var clippedValue = val.clip(lo, hi);
    var normalizedValue = clippedValue.linlin(lo, hi, 0, 1);
    state.tracks[trackIndex][param] = clippedValue;
    busses.tracks[trackIndex][param].set(clippedValue);
    eventBroker.publish((
      topic: \track,
      index: trackIndex,
      param: param,
      val: state.tracks[trackIndex][param],
      normalized: normalizedValue
    ))
  };
  var setTrackSample = { |trackIndex, sampleIndex|
    var clippedValue = sampleIndex.clip(0, samples.size);
    var normalizedValue = clippedValue.linlin(0, samples.size, 0, 1);
    var sample = samples[clippedValue];
    state.tracks[trackIndex].sampleIndex = clippedValue;
    busses.tracks[trackIndex].sampleIndex.set(clippedValue);
    eventBroker.publish((
      topic: \track,
      index: trackIndex,
      param: \sampleIndex,
      val: clippedValue,
      normalized: normalizedValue,
      name: sample.name,
      soundfile: sample.soundfile
    ))
  };
  var setMasterClippedParameter = { |param, val, lo, hi|
    var clippedValue = val.clip(lo, hi);
    var normalizedValue = clippedValue.linlin(lo, hi, 0, 1);
    state.master[param] = clippedValue;
    busses.master[param].set(clippedValue);
    eventBroker.publish((
      topic: \master,
      index: 0,
      param: param,
      val: state.master[param],
      normalized: normalizedValue
    ))
  };
  var trackParameterFunctions = (
    offset: { |trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \offset, val, 0, 1)
    },
    window: { |trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \window, val, 0, 1)
    },
    rate: { |trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \rate, val, -2, 2)
    },
    lpfCutoff: { |trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \lpfCutoff, val, 0, 1)
    },
    lpfResonance: { |trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \lpfResonance, val, 0, 1);
    },
    hpfCutoff: { |trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \hpfCutoff, val, 0, 1)
    },
    volume: { |trackIndex, val|
      setTrackClippedParameter.value(trackIndex, \volume, val, 0, 1)
    },
    sampleIndex: { |trackIndex, val|
      setTrackSample.value(trackIndex, val);
    }
  );
  var masterParameterFunctions = (
    reverb: { |val|
      setMasterClippedParameter.value(\reverb, val, 0, 1)
    },
    distortion: { |val|
      setMasterClippedParameter.value(\distortion, val, 0, 1)
    },
    lpfCutoff: { |val|
      setMasterClippedParameter.value(\lpfCutoff, val, 0, 1)
    },
    hpfCutoff: { |val|
      setMasterClippedParameter.value(\hpfCutoff, val, 0, 1)
    },
    volume: { |val|
      setMasterClippedParameter.value(\volume, val, 0, 1)
    }
  );
  (
    initialize: { |self|
      var trackParams = trackParameterFunctions.keys.asArray;
      var masterParams = masterParameterFunctions.keys.asArray;
      state.tracks.do({ |track, trackIndex| 
        trackParams.do({ |param|
          self.resetTrackParameter(trackIndex, param);
        })
      });
      masterParams.do({ |param|
        self.resetMasterParameter(param);
      })
    },
    getTrackParameter: { |self, trackIndex, parameter|
      state.tracks[trackIndex][parameter];
    },
    setTrackParameter: { |self, trackIndex, parameter, val|
      trackParameterFunctions.at(parameter).value(trackIndex, val);
    },
    resetTrackParameter: { |self, trackIndex, parameter|
      var default = defaults.tracks[trackIndex][parameter];
      self.setTrackParameter(trackIndex, parameter, default);
    },
    getMasterParameter: { |self, parameter|
      state.master[parameter];
    },
    setMasterParameter: { |self, parameter, val|
      masterParameterFunctions.at(parameter).value(val);
    },
    resetMasterParameter: { |self, parameter|
      var default = defaults.master[parameter];
      self.setMasterParameter(parameter, default);
    }
  )
}
