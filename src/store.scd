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
      state.tracks[trackIndex][parameter].val;
    },
    setTrackParameter: { |self, trackIndex, parameter, val|
      trackParameterFunctions.at(parameter).value(trackIndex, val);
    },
    resetTrackParameter: { |self, trackIndex, parameter|
      var default = state.tracks[trackIndex][parameter].default;
      self.setTrackParameter(trackIndex, parameter, default);
    },
    getMasterParameter: { |self, parameter|
      state.master[parameter].val;
    },
    setMasterParameter: { |self, parameter, val|
      masterParameterFunctions.at(parameter).value(val);
    },
    resetMasterParameter: { |self, parameter|
      var default = state.master[parameter].default;
      self.setMasterParameter(parameter, default);
    }
  )
}
