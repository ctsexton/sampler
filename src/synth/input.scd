{ |bus, gainBus|
  var synth = Synth.new(\input, [
    \inputChannel, 1,
    \output, bus,
    \gain, 0
  ]);
  synth.map(\gain, gainBus);
}
