{ |topics|
  var subscribersByTopic = ();
  topics.do({ |topic|
    subscribersByTopic.put(topic, []);
  });
  (
    publish: { |self, event|
      subscribersByTopic.at(event.topic).do({ |subscriber|
        subscriber.notify(event);
      })
    },
    subscribe: { |self, topic, consumer|
      subscribersByTopic.put(
        topic,
        subscribersByTopic.at(topic).add(consumer)
      );
      subscribersByTopic.postln;
    }
  );
}
