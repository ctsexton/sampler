{ |config, sampler, eventBroker|
  var ui;
  var mft;
  var ctrlsInOrder = [\offset, \lpfCutoff, \rate, \volume];
  var ctrlXPositions = (
    offset: 0,
    lpfCutoff: 1,
    rate: 2,
    volume: 3
  );
  var masterCtrlsInOrder = [\reverb, \lpfCutoff, \hpfCutoff, \volume];
  var masterCtrlXPositions = (
    reverb: 0,
    lpfCutoff: 1,
    hpfCutoff: 2,
    volume: 3
  );
  MIDIClient.init;
  MIDIIn.connectAll;

  mft = MFT(MIDIEndPoint(config["MFTDeviceName"], config["MFTPortName"]));

  mft.gridResponderFunction = { |self, event|
    if (event.y < 3, {
      var param = ctrlsInOrder.at(event.x);
      var inc = event.vel * 0.01;
      var trackIndex = event.y;
      var currentValue = sampler.getTrackParameter(trackIndex, param);
      var newValue = currentValue + inc;
      sampler.setTrackParameter(trackIndex, param, newValue);
    }, {
      var param = masterCtrlsInOrder[event.x];
      var inc = event.vel * 0.01;
      var currentValue = sampler.getMasterParameter(param);
      var newValue = currentValue + inc;
      sampler.setMasterParameter(param, newValue);
    })
  };

  ui = (
    notify: { |self, msg|
      if (msg.topic == \track, {
        var level = 0;
        var x = ctrlXPositions.at(msg.param);
        var y = msg.index;
        var vel = msg.normalized;
        x.postln;
        if (x != nil, {
          mft.ledset(level, x, y, vel);
        })
      }, {
        var level = 0;
        var x = masterCtrlXPositions[msg.param];
        var y = 3;
        var vel = msg.normalized;
        if (x != nil, {
          mft.ledset(level, x, y, vel);
        })
      })
    }
  );
  eventBroker.subscribe([\track, \master], ui);
}
