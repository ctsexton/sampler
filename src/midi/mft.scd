var createAddress = "../util/createAddress.scd".loadRelative[0];

{ |config, controller, eventRouter|
  var mft;

  var subscribe = { |addressAsArray, action|
    var address = createAddress.value(addressAsArray);
    var ui = (
      notify: { |self, msg| action.value(msg) }
    );
    eventRouter.subscribe([address], ui)
  };

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

  var encoderFunctions = {
    var samplerFunctions = config.numTracks.collect({ |i|
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
          increment.value(['sampler', i, 'feedback'])
        ]
      ]
    });
    var delayverbFunctions = [
      [
        [
          increment.value(['delayverb', 'delay', 'drywet']),
          increment.value(['delayverb', 'reverb', 'drywet'])
        ],
        [
          increment.value(['delayverb', 'delay', 'feedback']),
          increment.value(['delayverb', 'delay', 'feedback'])
        ],
        [
          increment.value(['delayverb', 'intensity']),
          increment.value(['delayverb', 'intensity'])
        ],
        [
          increment.value(['delayverb', 'volume']),
          increment.value(['delayverb', 'volume'])
        ]
      ]
    ];
    samplerFunctions ++ delayverbFunctions;
  }.value();

  var clickFunctions = {
    var samplerFunctions = config.numTracks.collect({ |i|
      [
        [{}, {}],
        [{}, {}],
        [{}, reverse.value(['sampler', i, 'rate'])],
        [
          { controller.setParameter(createAddress.value(['sampler', i, 'record']), 0) },
          { controller.setParameter(createAddress.value(['sampler', i, 'record']), 1) }
        ]
      ]
    });
    var intensityTmp = 0;
    var delayverbFunctions = [
      [
        [{}, {}],
        [{}, {}],
        [{}, {}],
        [{}, {}]
      ]
    ];
    samplerFunctions ++ delayverbFunctions;
  }.value();

  var doubleClickFunctions = config.numTracks.collect({ |i|
    [
      resetBulk.value([['sampler', i, 'offset'], ['sampler', i, 'window']]),
      resetBulk.value([['sampler', i, 'lpf', 'cutoff'], ['sampler', i, 'lpf', 'resonance']]),
      {},
      reset.value(['sampler', i, 'volume'])
    ]
  });


  mft = MFT(MIDIEndPoint(config.mftDeviceName, config.mftPortName));

  mft.gridResponderFunction = { |self, event|
    encoderFunctions[event.y][event.x][event.level].value(event.vel);
  };

  mft.onDoubleClick = { |self, event| doubleClickFunctions[event.y][event.x].value() };

  mft.onClick = { |self, event|
    if (event.vel === 1, {
      clickFunctions[event.y][event.x][1].value()
    }, {
      clickFunctions[event.y][event.x][0].value()
    })
  };

  config.numTracks.do({ |i|
    subscribe.value(['sampler', i, 'offset'], { |msg| mft.ledset(0, 0, i, msg.normalized) });
    subscribe.value(['sampler', i, 'window'], { |msg| mft.ledset(1, 0, i, msg.normalized) });
    subscribe.value(['sampler', i, 'lpf', 'cutoff'], { |msg| mft.ledset(0, 1, i, msg.normalized) });
    subscribe.value(['sampler', i, 'lpf', 'resonance'], { |msg| mft.ledset(1, 1, i, msg.normalized) });
    subscribe.value(['sampler', i, 'rate'], { |msg|
      mft.ledset(0, 2, i, msg.normalized);
      mft.ledset(1, 2, i, msg.normalized);
    });
    subscribe.value(['sampler', i, 'volume'], { |msg|
      mft.ledset(0, 3, i, msg.normalized);
      mft.ledset(1, 3, i, msg.normalized);
    });
  });
  subscribe.value(['delayverb', 'delay', 'drywet'], { |msg| mft.ledset(0, 0, 2, msg.normalized) });
  subscribe.value(['delayverb', 'reverb', 'drywet'], { |msg| mft.ledset(1, 0, 2, msg.normalized) });
  subscribe.value(['delayverb', 'delay', 'feedback'], { |msg|
    mft.ledset(0, 1, 2, msg.normalized);
    mft.ledset(1, 1, 2, msg.normalized);
  });
  subscribe.value(['delayverb', 'intensity'], { |msg|
    mft.ledset(0, 2, 2, msg.normalized);
    mft.ledset(1, 2, 2, msg.normalized);
  });
  subscribe.value(['delayverb', 'volume'], { |msg|
    mft.ledset(0, 3, 2, msg.normalized);
    mft.ledset(1, 3, 2, msg.normalized);
  });
}
