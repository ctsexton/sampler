{ |numTracks|
  (
    tracks: Array.fill(numTracks, {
        (
          offset: (
            default: 0,
            val: 0,
            bus: Bus.control().set(0)
          ),
          window: (
            default: 1,
            val: 1,
            bus: Bus.control().set(1)
          ),
          rate: (
            default: 1,
            val: 1,
            bus: Bus.control().set(1)
          ),
          lpfCutoff: (
            default: 1,
            val: 1,
            bus: Bus.control().set(1)
          ),
          hpfCutoff: (
            default: 0,
            val: 0,
            bus: Bus.control().set(0)
          ),
          volume: (
            default: 0,
            val: 0,
            bus: Bus.control().set(0)
          ),
          sampleIndex: (
            default: 0,
            val: 0,
            bus: Bus.control().set(0)
          ),
          playhead: (
            default: 0,
            val: 0,
            bus: Bus.control().set(0)
          )
        )
      }
    ),
    master: (
      reverb: (
        default: 0,
        val: 0,
        bus: Bus.control().set(0)
      ),
      distortion: (
        default: 0,
        val: 0,
        bus: Bus.control().set(0)
      ),
      lpfCutoff: (
        default: 1,
        val: 1,
        bus: Bus.control().set(1)
      ),
      hpfCutoff: (
        default: 0,
        val: 0,
        bus: Bus.control().set(0)
      ),
      volume: (
        default: 0,
        val: 0,
        bus: Bus.control().set(0)
      )
    )
  )
}
