{ |config|
  var samples_dir = PathName(config.baseDir) +/+ PathName("/data/samples");
  var samples = samples_dir.files.collect({ |path|
    var buffer = Buffer.read(s, path.fullPath.asString);
    var soundfile = SoundFile.new.openRead(path.fullPath.asString);
    (
      soundfile: soundfile,
      buffer: buffer,
      frames: buffer.numFrames,
      name: path.fileNameWithoutExtension
    )
  });
  samples
}
