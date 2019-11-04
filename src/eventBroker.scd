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
    subscribe: { |self, topicsToSubscribe, consumer|
      topicsToSubscribe.do({ |topic|
        subscribersByTopic.put(
          topic,
          subscribersByTopic.at(topic).add(consumer)
        );
      })
    }
  );
}
