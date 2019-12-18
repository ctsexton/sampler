{ |config, sampler, eventBroker|
  var ui;
  var funcs;
  
  thisProcess.openUDPPort(5005);
  funcs = 4.collect({ |i|
    var address = '/2/fader' ++ (i + 2).asString;
    OSCFunc.new({ |msg| sampler.setTrackParameter(i, 'volume', msg[1]) }, address);
  });
  
  ui = (
    notify: { |self, msg|
      if (msg.topic == \track, {
        msg.postln;
      })
    }
  );
  eventBroker.subscribe([\track], ui)
}
