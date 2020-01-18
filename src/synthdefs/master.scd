var amplitudeWarp = \db.asWarp;
SynthDef(\master, { |input, out, monitor, outVolume, monitorVolume|
  var sig = In.ar(input, 2);

  var monitorOutput = sig.tanh * amplitudeWarp.map(monitorVolume.varlag(0.005));
  var output = sig.tanh * amplitudeWarp.map(outVolume.varlag(0.005));
  Out.ar(monitor, monitorOutput);
  Out.ar(out, output);
});
