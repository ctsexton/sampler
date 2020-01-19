{
  |controller, micInput, delayverbOutput|
  var synth;
  var buffer = Buffer.alloc(s, s.sampleRate, 2);
  var paramMap = [
    (
      ext: '/delayverb/volume',
      int: 'volume'
    ),
    (
      ext: '/delayverb/delay/drywet',
      int: 'delayDryWet'
    ),
    (
      ext: '/delayverb/delay/feedback',
      int: 'delayFeedback'
    ),
    (
      ext: '/delayverb/reverb/drywet',
      int: 'reverbDryWet'
    ),
    (
      ext: '/delayverb/intensity',
      int: 'intensity'
    )
  ];

  s.sync;
  synth = Synth.new(\delayverb, [
    \buffer, buffer,
    \input, micInput,
    \output, delayverbOutput,
    \delayDryWet, -1,
    \reverbDryWet, -1,
    \intensity, 0.25,
    \delayFeedback, 0.5,
    \volume, 0
  ]);

  paramMap.do({ |item|
    synth.map(item.int, controller.getBus(item.ext));
  });
}
