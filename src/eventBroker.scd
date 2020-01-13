{
  var subscribersByTopic = ();
  (
    addTopic: { |self, topic| subscribersByTopic.put(topic, []) },
    addTopics: { |self, topics|
      topics.do({ |topic|
        subscribersByTopic.put(topic, []);
      })
    },
    publish: { |self, event|
      subscribersByTopic.at(event.topic).do({ |subscriber|
        subscriber.notify(event);
      });
      subscribersByTopic.at(\all).do({ |subscriber|
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
