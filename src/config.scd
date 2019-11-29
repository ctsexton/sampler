{ |filePath|
  var doc = filePath.parseYAMLFile();
  (
    baseDir: doc["baseDir"],
    morphAddr: (
      host: doc["morphAddr"]["host"],
      post: doc["morphAddr"]["port"].asInteger
    ),
    enableMIDI: doc["enableMIDI"].asInteger.asBoolean,
    enableGUI: doc["enableGUI"].asInteger.asBoolean,
    freqscopeActive: doc["freqscopeActive"].asInteger.asBoolean,
    enableDebug: doc["debug"].asInteger.asBoolean,
    mftDeviceName: doc["mftDeviceName"],
    mftPortName: doc["mftPortName"],
    numTracks: doc["numTracks"].asInteger
  );
}
