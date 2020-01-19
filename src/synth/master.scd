{ |busses, controller|
  var output, masterInput;
  masterInput = Bus.audio(s, 2);
  { Out.ar(masterInput, Mix.ar(In.ar(busses, 2))) }.play;
  output = Synth.new(\master, [
    \input, masterInput,
    \out, 0,
    \monitor, 2,
    \outVolume, 0,
    \monitorVolume, 0
  ]);
  output.map(\outVolume, controller.getBus('/master/volume'));
  output.map(\monitorVolume, controller.getBus('/master/monitor/volume'));
}
