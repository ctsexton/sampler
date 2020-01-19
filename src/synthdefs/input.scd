var amplitudeWarp = \db.asWarp;
SynthDef.new(\input, { |inputChannel, output, gain|
  var sig = SoundIn.ar(inputChannel);
  sig = HPF.ar(sig, 40) * amplitudeWarp.map(gain.varlag(0.005));
  Out.ar(output, sig);
});
