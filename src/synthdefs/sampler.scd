var amplitudeWarp = \db.asWarp;
SynthDef(\windowLooper, {
  | buffer, rate, window, offset, playhead, volume, lpfCutoff, lpfResonance, hpfCutoff, status, prefilterOutput, output, record, input, feedback |
  var sig, bufFrames, prefilter, out, index, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, ramp, env, diff, playback, writeMix, recording;

  bufFrames = BufFrames.kr(buffer);

  outsideBoundsTrigger = LocalIn.ar();

  maxWindowSize = ((offset + window) > 1) * (1 - offset) + ((offset + window) <= 1) * window;
  resetPoint = ((rate >= 0) * offset) + ((rate < 0) * (offset + maxWindowSize));

  index = Phasor.ar(outsideBoundsTrigger, rate / bufFrames, 0, 1, resetPoint);
  isOutsideBounds = 1 - InRange.ar(index, offset, offset + maxWindowSize);
  LocalOut.ar(isOutsideBounds);
  Out.kr(playhead, index);
   
  playback = BufRd.ar(2, buffer, index * bufFrames, 1, 4);
  recording = In.kr(record);
  writeMix = (recording < 0.5) + (recording * In.kr(feedback));
  IBufWr.ar(In.ar(input, 2) * recording, buffer, index * bufFrames, 1, writeMix);

  // Ramp & Switch
  env = Env([1, 1, 0], [0, 512/SampleRate.ir]);
  ramp = EnvGen.ar(env, outsideBoundsTrigger);
  diff = Latch.ar(HPZ1.ar(playback, 2), outsideBoundsTrigger);

  sig = playback - (diff * ramp);
  prefilter = sig.tanh * amplitudeWarp.map(volume.varlag(0.005));
  out = HPF.ar(RLPF.ar(prefilter, lpfCutoff.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), lpfResonance.varlag(0.01).linlin(0, 1, 1, 0)), hpfCutoff.varlag(0.05).lincurve(0, 1, 30, 5000, 2));

  Out.ar(prefilterOutput, sig);
  Out.ar(output, out);
  FreeSelf.kr(status);
});

