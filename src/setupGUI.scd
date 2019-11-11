{ |config, sampler, eventBroker|
  var ui;
  "setting up GUI".postln;

  ui = (
    notify: { |self, msg|
      if (msg.topic == \track, {
        "GUI received a message!".postln;
        msg.postln;
      })
    }
  );
  eventBroker.subscribe([\track, \master], ui);
}
