{ |config|
  var samples_dir = PathName(config.baseDir) +/+ PathName("/data/samples");
  samples_dir.files.collect({ |path| Sample(path) });
}
