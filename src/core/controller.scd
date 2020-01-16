{ |parameterTree, eventRouter|
  var busses = ();
  var state = ();
  var parameters = ();
  var setters = (
    float: {|address, parameterConfig|
      {|self, val|
        var clippedValue = val.clip(parameterConfig.minimum, parameterConfig.maximum);
        var normalizedValue = clippedValue.linlin(parameterConfig.minimum, parameterConfig.maximum, 0, 1);
        state[address] = clippedValue;
        busses[address].set(clippedValue);
        eventRouter.publish((
          address: address,
          val: clippedValue,
          normalized: normalizedValue
        ))
      }
    },
    integer: {|address, parameterConfig|
      {|self, val|
        var clippedValue = val.clip(parameterConfig.minimum, parameterConfig.maximum).asInteger;
        var normalizedValue = clippedValue.linlin(parameterConfig.minimum, parameterConfig.maximum, 0, 1);
        state[address] = clippedValue;
        busses[address].set(clippedValue);
        eventRouter.publish((
          address: address,
          val: clippedValue,
          normalized: normalizedValue
        ))
      }
    },
    boolean: {|address, parameterConfig|
      {|self, val|
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
        eventRouter.publish((
          address: address,
          val: stateVal,
          normalized: busVal
        ))
      }
    },
    read_only: {|address, parameterConfig|
      {|self, val| val } // Do nothing for read only params
    }
  );

  var parameterTypes = [\float, \integer, \boolean, \read_only].asSet;

  var traverse = {|object, address=''| if (object.isKindOf(Dictionary), {
      if (parameterTypes.includes(object.type), {
        busses[address] = Bus.control().set(object.default);
        state[address] = object.default;
        parameters[address] = (
          getParameter: { state[address] },
          setParameter: setters[object.type].value(address, object),
          resetParameter: { |self| self.setParameter(object.default) }
        );
      }, {
        object.keysValuesDo({|key, val|
          var newAddress = address ++ '/' ++ key;
          traverse.value(val, newAddress.asSymbol);
        })
      })
    }, {
      object.do({|item, i|
        var newAddress = address ++ '/' ++ i.asString;
        traverse.value(item, newAddress.asSymbol);
      })
    })
  };
  traverse.value(parameterTree);

  (
    getParameter: { |self, address| parameters[address].getParameter() },
    resetParameter: { |self, address| parameters[address].resetParameter() },
    setParameter: { |self, address, val| parameters[address].setParameter(val) },
    initialize: { parameters.do({|item| item.resetParameter() })},
    listParameters: { parameters.keys },
    getBus: { |self, address| busses[address] }
  )
}
