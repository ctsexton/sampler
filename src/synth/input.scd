{ |bus, gainBus|
  var synth = Synth.new(\input, [
    \inputChannel, 0,
    \output, bus,
    \gain, 0
  ]);
  synth.map(\gain, gainBus);
}
