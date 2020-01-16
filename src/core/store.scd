{ |controller, parameters|
  var store =  ();
  var saveAllParameters = { |key|
    store[key] = ();
    parameters.do({|param|
      store[key][param] = controller.getParameter(param)
    });
  };

  var restoreAllParameters = { |key|
    store[key].keysValuesDo({ |k, val|
      controller.setParameter(k, val)
    })
  };

  var clearAllParameters = { store = () };

  var verify = { |key| store.includesKey(key) };

  var verifyBulk = { |keys|
    var verification = ();
    keys.do({ |key|
      verification[key] = store.includesKey(key);
    });
    verification
  };

  (
    save: { |self, key| saveAllParameters.value(key) },
    restore: { |self, key| restoreAllParameter.value(key) },
    clear: { clearAllParameter.value() }
  )
}
