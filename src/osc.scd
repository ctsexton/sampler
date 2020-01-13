{ |config, controller, eventBroker|
  var ui;
  var funcs = [];
  var netAddr = NetAddr.new(config.oscOutAddress, config.oscOutPort);
  
  thisProcess.openUDPPort(config.oscInPort);

  controller.listParameters().do({|address|
    funcs = funcs.add(OSCFunc.new({ |msg|
      controller.setParameter(address, msg[1])
    }, address));
  });
  
  ui = (
    notify: { |self, event|
      netAddr.sendMsg(event.topic, event.normalized);
    }
  );
  eventBroker.subscribe(controller.listParameters(), ui)
}
