var amplitudeWarp = \db.asWarp;
SynthDef.new(\samplerInputMixer, { |mic, dv, dvVol, out|
  var dvSig = In.ar(dv, 2) * amplitudeWarp.map(dvVol.varlag(0.005));
  var sig = Mix.ar([In.ar(mic, 2), dvSig]);
  Out.ar(out, sig);
});
