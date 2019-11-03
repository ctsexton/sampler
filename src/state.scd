{ |numTracks|
  (
    tracks: Array.fill(numTracks, {
        (
          offset: (
            val: 0,
            bus: Bus.control().set(0)
          ),
          window: (
            val: 1,
            bus: Bus.control().set(1)
          ),
          rate: (
            val: 1,
            bus: Bus.control().set(1)
          ),
          lpfCutoff: (
            val: 1,
            bus: Bus.control().set(1)
          ),
          hpfCutoff: (
            val: 0,
            bus: Bus.control().set(0)
          ),
          volume: (
            val: 0,
            bus: Bus.control().set(0)
          ),
          sampleIndex: (
            val: 0,
            bus: Bus.control().set(0)
          ),
          playhead: (
            val: 0,
            bus: Bus.control().set(0)
          )
        )
      }
    ),
    master: (
      reverb: (
        val: 0,
        bus: Bus.control().set(0)
      ),
      distortion: (
        val: 0,
        bus: Bus.control().set(0)
      ),
      lpfCutoff: (
        val: 1,
        bus: Bus.control().set(1)
      ),
      hpfCutoff: (
        val: 0,
        bus: Bus.control().set(0)
      ),
      volume: (
        val: 0,
        bus: Bus.control().set(0)
      )
    )
  )
}
