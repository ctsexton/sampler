{ |eventBroker|
  var ui = (
    notify: { |self, msg|
      msg.postln;
    }
  );
  eventBroker.subscribe([\track, \master], ui);
}
