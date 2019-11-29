{ |samples, state, busses|
  (
    start: {
      var synths, output, trackOutputs;
      trackOutputs = busses.tracks.collect({ |track| track.output });
      output = { Out.ar(0, Mix.ar(In.ar(trackOutputs))!2) }.play;
      s.sync;
      synths = Array.fill(3, { |i|
        var track = state.tracks[i];
        var trackBusses = busses.tracks[i];
        Synth.new(\windowLooper, [
          \buffer, samples[0].buffer,
          \rate, track.rate,
          \window, track.window,
          \offset, track.offset,
          \playhead, trackBusses.playhead,
          \lpfCutoff, track.lpfCutoff,
          \lpfResonance, track.lpfResonance,
          \hpfCutoff, track.hpfCutoff,
          \status, 0,
          \output, trackBusses.output,
          \prefilterOutput, trackBusses.prefilter,
          \volume, track.volume
        ])
      });
      synths.do({ |item, i| item.map(
        \offset, busses.tracks[i].offset,
        \window, busses.tracks[i].window,
        \rate, busses.tracks[i].rate,
        \volume, busses.tracks[i].volume,
        \lpfCutoff, busses.tracks[i].lpfCutoff,
        \lpfResonance, busses.tracks[i].lpfResonance
      )});
    }
  )
}