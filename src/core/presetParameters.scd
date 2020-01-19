var createAddress = "../util/createAddress.scd".loadRelative[0];

{ |config|
  var samplerParams = Array.fill(config.numTracks, { |i|
    [
      createAddress.value(['sampler', i, 'offset']),
      createAddress.value(['sampler', i, 'window']),
      createAddress.value(['sampler', i, 'rate']),
      createAddress.value(['sampler', i, 'lpf', 'cutoff']),
      createAddress.value(['sampler', i, 'lpf', 'resonance']),
      createAddress.value(['sampler', i, 'hpf', 'cutoff']),
      createAddress.value(['sampler', i, 'hpf', 'resonance']),
      createAddress.value(['sampler', i, 'volume']),
      createAddress.value(['sampler', i, 'sampleIndex'])
    ]
  });
  var allParametersForPresets = [
    samplerParams
  ].flat;
  allParametersForPresets;
}
