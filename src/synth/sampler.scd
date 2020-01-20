var createAddress = "../util/createAddress.scd".loadRelative[0];

{ |config, samples, controller, eventRouter, outputBusses|
  var synths, output, playheads, masterInput;
  var paramMap = [
    (
      ext: 'volume',
      int: 'volume'
    ),
    (
      ext: 'lpf/cutoff',
      int: 'lpfCutoff'
    ),
    (
      ext: 'lpf/resonance',
      int: 'lpfResonance'
    ),
    (
      ext: 'hpf/cutoff',
      int: 'hpfCutoff'
    ),
    (
      ext: 'hpf/resonance',
      int: 'hpfResonance'
    ),
    (
      ext: 'offset',
      int: 'offset'
    ),
    (
      ext: 'window',
      int: 'window'
    ),
    (
      ext: 'rate',
      int: 'rate'
    )
  ];

  playheads = config.numTracks.collect({ Bus.control() });
  synths = config.numTracks.collect({ |i|
    var params = paramMap.collect({ |item|
      var address = createAddress.value(['sampler', i, item.ext]);
      [item.int, controller.getParameter(address)];
    });

    params = params.add([\playhead, playheads[i]]);
    params = params.add([\output, outputBusses[i]]);
    params = params.add([\buffer, samples[i][0].buffer]);
    params = params.add([\status, 0]);
    params = params.add([\prefilterOutput, Bus.audio(s, 2)]);

    Synth.new(\windowLooper, params.flat);
  });

  synths.do({ |synth, i|
    var sampleIndexAddress = createAddress.value(['sampler', i, 'sampleIndex']);
    var sampleIndexAction = ( notify: { |self, msg|
      synth.set(\buffer, samples[i][msg.val].buffer);
    });
    eventRouter.subscribe([sampleIndexAddress], sampleIndexAction);
    paramMap.do({ |item|
      var address = createAddress.value(['sampler', i, item.ext]);
      synth.map(item.int, controller.getBus(address));
    });
  });

  s.sync;
  // Send messages for GUI monitoring
  config.numTracks.do({ |i|
    var playheadAddr = createAddress.value(['sampler', i, 'playhead']);
    var levelAddr = createAddress.value(['sampler', i, 'level']);
    {
      SendReply.kr(Impulse.kr(50), playheadAddr, In.kr(playheads[i]));
      SendPeakRMS.kr(In.ar(outputBusses[i], 2), 20, 3, levelAddr);
    }.play(addAction: \addToTail);
  });
}
