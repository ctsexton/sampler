{ |config, sampler, eventBroker|
  var ui;
  var mft;
  var inputMap = [[\offset, \window], [\lpfCutoff, \lpfResonance], [\rate, \rate], [\volume, \volume]];
  var outputMap = (
    offset: [(x: 0, level: 0)],
    window: [(x: 0, level: 1)],
    lpfCutoff: [(x: 1, level: 0)],
    lpfResonance: [(x: 1, level: 1)],
    rate: [(x: 2, level: 0), (x: 2, level: 1)],
    volume: [(x: 3, level: 0), (x: 3, level: 1)]
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
      var param = inputMap[event.x][event.level];
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

  mft.onDoubleClick = { |self, event|
    if (event.y < 3, {
      var params = inputMap[event.x].asSet;
      var trackIndex = event.y;
      params.do({ |param| sampler.resetTrackParameter(trackIndex, param)});
    })
  };

  mft.onClick = { |self, event|
    if (event.y < 3 && inputMap[event.x][0] == \rate && event.vel == 1, {
      var trackIndex = event.y;
      var currentValue = sampler.getTrackParameter(trackIndex, \rate);
      sampler.setTrackParameter(trackIndex, \rate, currentValue * -1);
    })
  };

  ui = (
    notify: { |self, msg|
      if (msg.topic == \track, {
        var ctrls = outputMap[msg.param];
        var y = msg.index;
        var vel = msg.normalized;
        if (ctrls != nil, {
          ctrls.do({ |ctrl| mft.ledset(ctrl.level, ctrl.x, y, vel) });
        });
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
