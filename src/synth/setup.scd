var createMaster = "./master.scd".loadRelative[0];
var createSampler = "./sampler.scd".loadRelative[0];
var createDelayverb = "./delayverb.scd".loadRelative[0];
var createInput = "./input.scd".loadRelative[0];

{ |config, samples, controller, eventRouter|

  (
    start: {
      var samplerOutputs, delayverbOutput, micInput;
      micInput = Bus.audio(s, 2);
      delayverbOutput = Bus.audio(s, 2);
      samplerOutputs = config.numTracks.collect({ Bus.audio(s, 2) });
      createMaster.value([samplerOutputs, delayverbOutput].flat, controller);

      s.sync;

      createSampler.value(config, samples, controller, eventRouter, samplerOutputs);
      createDelayverb.value(controller, eventRouter, micInput, delayverbOutput);

      s.sync;
      
      createInput.value(micInput);
    }
  )
}
