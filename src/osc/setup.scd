{ |config, controller, eventRouter|
  var ui;
  var funcs = [];
  var netAddr = NetAddr.new(config.oscOutAddress, config.oscOutPort);
  
  thisProcess.openUDPPort(config.oscInPort);

  controller.listParameters().do({|address|
    funcs = funcs.add(OSCFunc.new({ |msg|
      controller.setParameter(address, msg[1])
    }, address));
  });

  OSCFunc.new({ |msg|
    netAddr.sendMsg('/pong', msg[1]);
  }, '/ping');
  
  ui = (
    notify: { |self, event|
      netAddr.sendMsg(event.address, event.normalized);
    }
  );
  eventRouter.subscribe(controller.listParameters(), ui)
}
