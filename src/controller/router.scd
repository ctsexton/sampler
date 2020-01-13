{ |initialParameters, eventBroker|
  var busses = ();
  var state = ();
  var parameters = ();
  var setters = (
    float: {|address, parameterConfig|
      {|val|
        var clippedValue = val.clip(parameterConfig.minimum, parameterConfig.maximum);
        var normalizedValue = clippedValue.linlin(parameterConfig.minimum, parameterConfig.maximum, 0, 1);
        state[address] = clippedValue;
        busses[address].set(clippedValue);
        eventBroker.publish((
          address: address,
          val: clippedValue,
          normalized: normalizedValue
        ))
      }
    },
    integer: {|address, parameterConfig|
      {|val|
        var clippedValue = val.clip(parameterConfig.minimum, parameterConfig.maximum).asInteger;
        var normalizedValue = clippedValue.linlin(parameterConfig.minimum, parameterConfig.maximum, 0, 1);
        state[address] = clippedValue;
        busses[address].set(clippedValue);
        eventBroker.publish((
          address: address,
          val: clippedValue,
          normalized: normalizedValue
        ))
      }
    },
    boolean: {|address, parameterConfig|
      {|val|
        var stateVal, busVal;
        if (val, {
          stateVal = true;
          busVal = 1;
        }, {
          stateVal = false;
          busVal = 0;
        });
        state[address] = stateVal;
        busses[address].set(busVal);
        eventBroker.publish((
          address: address,
          val: stateVal,
          normalized: busVal
        ))
      }
    }
  );

  var parameterTypes = [\float, \integer, \boolean].asSet;

  var traverse = {|object, address=""|
    if (object.isKindOf(Dictionary), {
      if (parameterTypes.includes(object.type), {
        address.postln;
        busses[address] = Bus.control().set(object.default);
        state[address] = object.default;
        parameters[address] = (
          get: state[address],
          set: setters[object.type].value(address, object),
          reset: { |self| self.set(object.default) }
        );
      }, {
        object.keysValuesDo({|key, val|
          var newAddress = address ++ "/" ++ key;
          traverse.value(val, newAddress);
        })
      })
    }, {
      object.do({|item, i|
        var newAddress = address ++ "/" ++ i.asString;
        traverse.value(item, newAddress);
      })
    })
  };
  traverse.value(initialParameters);

  (
    get: { |self, address| parameters[address][\get].value() },
    reset: { |self, address| parameters[address].reset() },
    set: { |self, address, val| parameters[address][\set].value(val) }
  )
}
