{
  |controller, eventRouter, micInput, delayverbOutput|
  var buffer = Buffer.alloc(s, s.sampleRate, 2);
  s.sync;
  Synth.new(\delayverb, [
    \buffer, buffer,
    \input, micInput,
    \output, delayverbOutput,
    \delayDryWet, 1,
    \reverbDryWet, -1,
    \intensity, 0.5,
    \delayFeedback, 0.5,
    \volume, 1
  ]);
}
