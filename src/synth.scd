{ |samples, state|
  (
    start: {
    var synths = Array.fill(3, { |i|
      var track = state.tracks[i];
      Synth.new(\windowLooper, [
        \buffer, samples[0].buffer,
        \rate, track.rate.val,
        \window, track.window.val,
        \offset, track.offset.val,
        \playhead, track.playhead.bus,
        \lpfCutoff, track.lpfCutoff.val,
        \lpfResonance, track.lpfResonance.val,
        \hpfCutoff, track.hpfCutoff.val,
        \status, 0,
        \output, 0,
        \volume, track.volume.val
      ])});
      synths.do({ |item, i| item.map(
        \offset, state.tracks[i].offset.bus,
        \window, state.tracks[i].window.bus,
        \rate, state.tracks[i].rate.bus,
        \volume, state.tracks[i].volume.bus,
        \lpfCutoff, state.tracks[i].lpfCutoff.bus,
        \lpfResonance, state.tracks[i].lpfResonance.bus
      )});
    }
  )
}
