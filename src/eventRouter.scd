{
  var subscribersByAddress = ();
  (
    addAddress: { |self, address| subscribersByAddress.put(address, []) },
    addAddresses: { |self, addresses|
      addresses.do({ |address|
        subscribersByAddress.put(address, []);
      })
    },
    publish: { |self, event|
      subscribersByAddress.at(event.address).do({ |subscriber|
        subscriber.notify(event);
      });
      subscribersByAddress.at(\all).do({ |subscriber|
        subscriber.notify(event);
      })
    },
    subscribe: { |self, addressesToSubscribe, subscriber|
      addressesToSubscribe.do({ |address|
        subscribersByAddress.put(
          address,
          subscribersByAddress.at(address).add(subscriber)
        );
      })
    }
  );
}
