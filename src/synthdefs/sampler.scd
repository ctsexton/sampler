var amplitudeWarp = \db.asWarp;
SynthDef(\windowLooper, {
  | buffer, rate, window, offset, playhead, volume, lpfCutoff, lpfResonance, hpfCutoff, status, output |
  var bufFrames, out, index, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, ramp, env, diff, playback;

  bufFrames = BufFrames.kr(buffer);

  outsideBoundsTrigger = LocalIn.ar();

  maxWindowSize = ((offset + window) > 1) * (1 - offset) + ((offset + window) <= 1) * window;
  resetPoint = ((rate >= 0) * offset) + ((rate < 0) * (offset + maxWindowSize));

  index = Phasor.ar(outsideBoundsTrigger, rate / bufFrames, 0, 1, resetPoint);
  isOutsideBounds = 1 - InRange.ar(index, offset, offset + maxWindowSize);
  LocalOut.ar(isOutsideBounds);
  Out.kr(playhead, index * bufFrames);
   
  playback = BufRd.ar(2, buffer, index * bufFrames, 1, 4);

  // Ramp & Switch
  env = Env([1, 1, 0], [0, 512/SampleRate.ir]);
  ramp = EnvGen.ar(env, outsideBoundsTrigger);
  diff = Latch.ar(HPZ1.ar(playback, 2), outsideBoundsTrigger);

  out = playback - (diff * ramp);
  out = out.tanh * amplitudeWarp.map(volume.varlag(0.005));
  out = HPF.ar(RLPF.ar(out, lpfCutoff.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), lpfResonance.varlag(0.01).linlin(0, 1, 0, 1)), hpfCutoff.varlag(0.05).lincurve(0, 1, 30, 5000, 2));

  Out.ar(output, out);
  FreeSelf.kr(status);
});

