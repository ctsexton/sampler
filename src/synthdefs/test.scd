SynthDef(\test, {
  |volume, pitch, cutoff|
  var sig;
  
  sig = Saw.ar(pitch.varlag(0.03).linexp(0, 1, 25, 1000));
  sig = RLPFD.ar(sig, cutoff.varlag(0.05).linexp(0, 1, 50, 2500)) * 2;
  sig = sig * volume.varlag(0.05).lincurve(0, 1, 0, 1, 4);
  Out.ar(0, sig!2);
});
