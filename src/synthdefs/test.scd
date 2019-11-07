SynthDef(\test, {
  |volume, pitch|
  var sig;
  
  sig = SinOsc.ar(pitch.linexp(0, 1, 250, 2000).poll);
  sig = sig * volume.varlag(0.05).lincurve(0, 1, 0, 1, 4).poll;
  Out.ar(0, sig!2);
});
