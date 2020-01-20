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

      createSampler.value(config, samples, controller, eventRouter, samplerOutputs, micInput);
      createDelayverb.value(controller, micInput, delayverbOutput);

      s.sync;
      
      createInput.value(micInput, controller.getBus('/input/0/gain'));
    }
  )
}
