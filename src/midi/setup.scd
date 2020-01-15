var createAddress = "../util/createAddress.scd".loadRelative[0];

{ |config, controller, eventBroker|
  var ui;
  var mft;

  var increment = { |addressAsArray|
    var address = createAddress.value(addressAsArray); 
    { |inc|
      var value = controller.getParameter(address);
      controller.setParameter(address, value + (inc * 0.01));
    }
  };

  var reset = { |addressAsArray|
    var address = createAddress.value(addressAsArray);
    { controller.resetParameter(address) }
  };

  var resetBulk = { |addressesAsArrays|
    var addresses = addressesAsArrays.collect({ |arr| createAddress.value(arr) });
    { addresses.do({ |addr| controller.resetParameter(addr) })};
  };
  
  var reverse = { |addressAsArray|
    var address = createAddress.value(addressAsArray);
    { 
      var value = controller.getParameter(address);
      controller.setParameter(address, value * -1);
    }
  };

  var encoderFunctions = config.numTracks.collect({ |i|
    [
      [
        increment.value(['sampler', i, 'offset']),
        increment.value(['sampler', i, 'window'])
      ],
      [
        increment.value(['sampler', i, 'lpf', 'cutoff']),
        increment.value(['sampler', i, 'lpf', 'resonance'])
      ],
      [
        increment.value(['sampler', i, 'rate']),
        increment.value(['sampler', i, 'rate'])
      ],
      [
        increment.value(['sampler', i, 'volume']),
        increment.value(['sampler', i, 'volume'])
      ]
    ]
  });

  var clickFunctions = config.numTracks.collect({ |i|
    [
      {},
      {},
      reverse.value(['sampler', i, 'rate']),
      {}
    ]
  });

  var doubleClickFunctions = config.numTracks.collect({ |i|
    [
      resetBulk.value([['sampler', i, 'offset'], ['sampler', i, 'window']]),
      resetBulk.value([['sampler', i, 'lpf', 'cutoff'], ['sampler', i, 'lpf', 'resonance']]),
      {},
      reset.value(['sampler', i, 'volume'])
    ]
  });

  MIDIClient.init;
  MIDIIn.connectAll;

  mft = MFT(MIDIEndPoint(config.mftDeviceName, config.mftPortName));

  mft.gridResponderFunction = { |self, event|
    encoderFunctions[event.y][event.x][event.level].value(event.vel);
  };

  mft.onDoubleClick = { |self, event| doubleClickFunctions[event.y][event.x].value() };

  mft.onClick = { |self, event|
    if (event.vel == 1, {
      clickFunctions[event.y][event.x].value()
    })
  };

  /*
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
  */
}
