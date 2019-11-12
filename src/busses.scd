{ |state|
  (
    tracks: Array.fill(state.tracks.size, { |i|
        (
          offset: Bus.control().set(state.tracks[i].offset),
          window: Bus.control().set(state.tracks[i].window),
          rate: Bus.control().set(state.tracks[i].rate),
          lpfCutoff: Bus.control().set(state.tracks[i].lpfCutoff),
          lpfResonance: Bus.control().set(state.tracks[i].lpfResonance),
          hpfCutoff: Bus.control().set(state.tracks[i].hpfCutoff),
          volume: Bus.control().set(state.tracks[i].volume),
          sampleIndex: Bus.control().set(state.tracks[i].sampleIndex),
          playhead: Bus.control().set(state.tracks[i].playhead),
          output: Bus.audio(s, 2),
          prefilter: Bus.audio(s, 2)
        )
      }
    ),
    master: (
      reverb: Bus.control().set(state.master.reverb),
      distortion: Bus.control().set(state.master.distortion),
      lpfCutoff: Bus.control().set(state.master.lpfCutoff),
      hpfCutoff: Bus.control().set(state.master.hpfCutoff),
      volume: Bus.control().set(state.master.volume),
      output: Bus.audio(s, 2)
    )
  )
}
