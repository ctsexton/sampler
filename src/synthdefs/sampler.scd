var amplitudeWarp = \db.asWarp;
SynthDef(\windowLooper, {
  arg buffer, rateBus, windowBus, offsetBus, playheadBus, volumeBus, lpfCutoffBus, hpfCutoffBus, status, outputBus;
  var out, index, resetPoint, isOutsideBounds, maxWindowSize, outsideBoundsTrigger, previousIndex, ramp, env, diff, playback;

  var rate = In.kr(rateBus);
  var window = In.kr(windowBus);
  var offset = In.kr(offsetBus);
  var volume = In.kr(volumeBus);
  var lpfCutoff = In.ar(lpfCutoffBus);
  var hpfCutoff = In.ar(hpfCutoffBus);
  var bufFrames = BufFrames.kr(buffer);

  outsideBoundsTrigger = LocalIn.ar();

  maxWindowSize = ((position + window) > 1) * (1 - position) + ((position + window) <= 1) * window;
  resetPoint = ((rate >= 0) * position) + ((rate < 0) * (position + maxWindowSize));

  index = Phasor.ar(outsideBoundsTrigger, rate / bufFrames, 0, 1, resetPoint);
  isOutsideBounds = 1 - InRange.ar(index, position, position + maxWindowSize);
  LocalOut.ar(isOutsideBounds)
  Out.kr(playheadBus, index * bufFrames);
   
  playback = BufRd.ar(2, buffer, index * bufFrames, 1, 4);

  // Ramp & Switch
  env = Env([1, 1, 0], [0, 512/SampleRate.ir]);
  ramp = EnvGen.ar(env, outsideBoundsTrigger);
  diff = Latch.ar(HPZ1.ar(playback, 2), outsideBoundsTrigger);

  out = playback - (diff * ramp);
  out = out.tanh * amplitudeWarp.map(volume.varlag(0.005));
  out = HPF.ar(RLPF.ar(out, lpfCutoff.varlag(0.01).lincurve(0, 1, 20, 10000, 2.5), 1), hpfCutoff.varlag(0.05).lincurve(0, 1, 30, 5000, 2));

  Out.ar(outputBus, out);
  FreeSelf.kr(status);
});

