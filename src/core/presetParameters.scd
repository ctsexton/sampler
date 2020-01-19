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
  var delayverbParams = [
    createAddress.value(['delayverb', 'volume']),
    createAddress.value(['delayverb', 'delay', 'drywet']),
    createAddress.value(['delayverb', 'reverb', 'drywet']),
    createAddress.value(['delayverb', 'delay', 'feedback']),
    createAddress.value(['delayverb', 'delay', 'feedback']),
    createAddress.value(['delayverb', 'intensity']),
    createAddress.value(['delayverb', 'intensity'])
  ];
  var allParametersForPresets = [
    samplerParams,
    delayverbParams
  ].flat;
  allParametersForPresets;
}
