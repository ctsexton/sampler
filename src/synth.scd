{ |config, samples, controller|
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

  (
    start: {
      var synths, output, trackOutputs;
      trackOutputs = config.numTracks.collect({ Bus.audio(s, 2) });
      output = { Out.ar(0, Mix.ar(In.ar(trackOutputs, 2))) }.play;
      s.sync;

      synths = config.numTracks.collect({ |i|
        var params = paramMap.collect({ |item|
          var address = ['', 'sampler', i, item.ext].join("/").asSymbol;
          [item.int, controller.getParameter(address)];
        });
        var playhead = Bus.control();

        params = params.add([\playhead, playhead]);
        params = params.add([\output, trackOutputs[i]]);
        params = params.add([\buffer, samples[0].buffer]);
        params = params.add([\status, 0]);
        params = params.add([\prefilterOutput, Bus.audio(s, 2)]);

        Synth.new(\windowLooper, params.flat);
      });

      synths.do({ |sampler, i|
        paramMap.do({ |item|
          var address = ['', 'sampler', i, item.ext].join("/").asSymbol;
          sampler.map(item.int, controller.getBus(address));
        })
      });

      s.sync;
      // Send messages for GUI monitoring
      /* busses.tracks.do({ |track, i| */
      /*   var playheadAddr = '/track_playhead_' ++ i; */
      /*   var levelAddr = '/track_level_' ++ i; */
      /*   { */
      /*     SendReply.kr(Impulse.kr(50), playheadAddr, In.kr(track.playhead)); */
      /*     SendPeakRMS.kr(In.ar(track.output, 2), 20, 3, levelAddr); */
      /*   }.play(addAction: \addToTail); */
      /* }); */
    }
  )
}
