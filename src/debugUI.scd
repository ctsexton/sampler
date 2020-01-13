{ |eventBroker|
  var ui = (
    notify: { |self, msg|
      msg.postln;
    }
  );
  eventBroker.subscribe([\all], ui);
}
