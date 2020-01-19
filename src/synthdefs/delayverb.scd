var amplitudeWarp = \db.asWarp;
SynthDef.new(\delayverb, { |buffer, input, output, delayDryWet, reverbDryWet, intensity, delayFeedback, volume|
  var sig, delaySig, index, reverbSig, rate, out, direction;
  sig = In.ar(input, 2);

  // Delay
  /* direction = (LFNoise0.kr(intensity.linlin(0, 1, 0.5, 10)) > 0.5) * 2 - 1; */
  /* rate = direction * Lag.kr(LFNoise0.kr(intensity.linlin(0, 1, 10, 30))) * intensity.linlin(0, 1, 1, 10); */
  /* index = Phasor.ar(0, rate, 0, BufFrames.kr(buffer)); */
  index = Phasor.ar(0, ((LFNoise0.kr(2) > 0.5) * -1) + Lag.kr(LFNoise0.kr(10), 0.1) * 2, 0, 44100);
  delaySig = BufRd.ar(2, buffer, index);
  delaySig = XFade2.ar(sig, delaySig, delayDryWet);
  IBufWr.ar(sig, buffer, index, 1, delayFeedback);

  // Reverb
  reverbSig = DelayN.ar(delaySig, 0.048);
  reverbSig = Mix.ar(Array.fill(7,{ CombL.ar(reverbSig, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));
  4.do({ reverbSig = AllpassN.ar(reverbSig, 0.050, [0.050.rand, 0.050.rand], 1) });

  out = XFade2.ar(delaySig, reverbSig, reverbDryWet);
  out = out.tanh * amplitudeWarp.map(volume.varlag(0.005));
  Out.ar(output, out);
});
