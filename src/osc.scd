{ |config, sampler, eventBroker, state|
  var ui;
  var funcs = [];
  var netAddr = NetAddr.new(config.oscOutAddress, config.oscOutPort);
  
  thisProcess.openUDPPort(config.oscInPort);

  state.tracks.do({|trk, i|
    trk.keysDo({|key|
      var addr = '/track/' ++ i ++ '/' ++ key;
      var oscFunc = OSCFunc.new({ |msg|
        sampler.setTrackParameter(i, key, msg[1])
      }, addr);
      funcs = funcs.add(oscFunc);
    });
  });
  funcs.postln;
  
  ui = (
    notify: { |self, msg|
      netAddr.sendMsg(
        '/' ++ msg.topic ++ '/' ++ msg.index ++ '/' ++ msg.param,
        msg.normalized);
    }
  );
  eventBroker.subscribe([\track], ui)
}
