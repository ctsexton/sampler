{ |numSamplers|
  (
    sampler: Array.fill(numSamplers, {
      (
        offset: (
          default: 0,
          minimum: 0,
          maximum: 0.999,
          type: \float
        ),
        window: (
          default: 1,
          minimum: 0.001,
          maximum: 1,
          type: \float
        ),
        rate: (
          default: 1,
          minimum: -2,
          maximum: 2,
          type: \float
        ),
        lpf: (
          cutoff: (
            default: 1,
            minimum: 0,
            maximum: 1,
            type: \float
          ),
          resonance: (
            default: 0.5,
            minimum: 0,
            maximum: 1,
            type: \float
          )
        ),
        hpf: (
          cutoff: (
            default: 0,
            minimum: 0,
            maximum: 1,
            type: \float
          ),
          resonance: (
            default: 0.5,
            minimum: 0,
            maximum: 1,
            type: \float
          )
        ),
        volume: (
          default: 0,
          minimum: 0,
          maximum: 1,
          type: \float
        ),
        mute: (
          default: false,
          type: \boolean
        ),
        sampleIndex: (
          default: 0,
          minimum: 0,
          maximum: 0,
          type: \integer
        ),
        playhead: (
          default: 0,
          minimum: 0,
          maximum: 1,
          type: \float
        ),
        jitter: (
          default: 0,
          minimum: 0,
          maximum: 1,
          type: \float
        )
      )
    }),
    master: (
      reverb: (
        (
          length: (
            default: 0.25,
            minimum: 0,
            maximum: 1,
            type: \float
          ),
          drywet: (
            default: 0,
            minimum: 0,
            maximum: 1,
            type: \float
          ),
          feedback: (
            default: 0,
            minimum: 0,
            maximum: 1,
            type: \float
          )
        )
      ),
      delay: (
        (
          length: (
            default: 0.25,
            minimum: 0,
            maximum: 1,
            type: \float
          ),
          drywet: (
            default: 0,
            minimum: 0,
            maximum: 1,
            type: \float
          ),
          feedback: (
            default: 0,
            minimum: 0,
            maximum: 1,
            type: \float
          )
        )
      )
      distortion: (
        default: 0,
        minimum: 0,
        maximum: 1,
        type: \float
      ),
      lpf: (
        cutoff: (
          default: 1,
          minimum: 0,
          maximum: 1,
          type: \float
        ),
        resonance: (
          default: 0.5,
          minimum: 0,
          maximum: 1,
          type: \float
        )
      ),
      hpf: (
        cutoff: (
          default: 0,
          minimum: 0,
          maximum: 1,
          type: \float
        ),
        resonance: (
          default: 0.5,
          minimum: 0,
          maximum: 1,
          type: \float
        )
      ),
      mute: (
        default: false,
        type: \boolean
      ),
      volume: (
        default: 0,
        minimum: 0,
        maximum: 1,
        type: \float
      ),
      monitor: (
        volume: (
          default: 0,
          minimum: 0,
          maximum: 1,
          type: \float
        ),
        mute: (
          default: false,
          type: \boolean
        )
      )
    )
  )
}
