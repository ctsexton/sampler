var createMaster = "./master.scd".loadRelative[0];
var createSampler = "./sampler.scd".loadRelative[0];

{ |config, samples, controller, eventRouter|

  (
    start: {
      var samplerOutputs;
      samplerOutputs = config.numTracks.collect({ Bus.audio(s, 2) });
      createMaster.value(samplerOutputs, controller);

      s.sync;
      
      createSampler.value(config, samples, controller, eventRouter, samplerOutputs);
    }
  )
}
