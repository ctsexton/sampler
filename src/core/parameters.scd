{ |numSamplers|
  (
    input: Array.fill(1, {
      (
        gain: (
          default: 0,
          minimum: 0,
          maximum: 1,
          type: \float
        )
      )
    }),
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
        level: (
          type: \read_only,
          default: 0
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
          maximum: 2,
          type: \integer
        ),
        playhead: (
          type: \read_only,
          default: 0
        ),
        jitter: (
          default: 0,
          minimum: 0,
          maximum: 1,
          type: \float
        )
      )
    }),
    delayverb: (
      volume: (
        default: 0,
        minimum: 0,
        maximum: 1,
        type: \float
      ),
      delay: (
        drywet: (
          default: -1,
          minimum: -1,
          maximum: 1,
          type: \float
        ),
        feedback: (
          default: 0.5,
          minimum: 0,
          maximum: 1,
          type: \float
        )
      ),
      reverb: (
        drywet: (
          default: -1,
          minimum: -1,
          maximum: 1,
          type: \float
        )
      ),
      intensity: (
        default: 0.25,
        minimum: 0,
        maximum: 1,
        type: \float
      )
    ),
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
