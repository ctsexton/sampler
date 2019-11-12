{ |numTracks|
  (
    tracks: Array.fill(numTracks, {
        (
          offset: 0,
          window: 1,
          rate: 1,
          lpfCutoff: 1,
          lpfResonance: 0.5,
          hpfCutoff: 0,
          volume: 0,
          sampleIndex: 0,
          playhead: 0
        )
      }
    ),
    master: (
      reverb: 0,
      distortion: 0,
      lpfCutoff: 1,
      hpfCutoff: 0,
      volume: 0
    )
  )
}
