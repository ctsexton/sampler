{ |parent, playheadOscAddr, action|
  var view,
    soundfile,
    offset,
    window, 
    timeCursorAnimation, 
    started, 
    updateTimeCursor, 
    timeCursorLoop,
    updateOffset, 
    updateWindow, 
    updateSoundfile;

  started = false;
  offset = 0;
  window = 1;
  view = SoundFileView(parent, Rect(0, 0, parent.bounds.width, parent.bounds.height));

  view.resize = 5;
  view.gridOn = false;
  view.peakColor = Color.new(0.85, 0.55, 0.85);
  view.rmsColor = Color.new(0.8, 0.5, 0.8);
  view.setSelectionColor(0, Color.new(1, 1, 1, 0.2));
  view.timeCursorOn = true;
  view.timeCursorColor = Color.red;
  view.mouseUpAction = {
    var offset, window, tuple, frames;
    frames = view.numFrames;
    tuple = view.selections[view.currentSelection];
    offset = tuple[0] / frames;
    window = tuple[1] / frames;
    action.value(offset, window);
  };

  updateOffset = { { view.setSelectionStart(0, offset * view.numFrames) }.defer };
  updateWindow = { { view.setSelectionSize(0, window * view.numFrames) }.defer };
  updateSoundfile = {
    if (soundfile != view.soundfile,
      {
        {
          view.soundfile = soundfile;
          view.read(0, soundfile.numFrames);
          view.refresh;
        }.defer;
        updateOffset.value();
        updateWindow.value();
      }
    )
  };

  (
    setSoundfile: { |self, newSoundFile|
      soundfile = newSoundFile;
      updateSoundfile.value();
    },
    setOffset: { |self, newOffset|
      offset = newOffset;
      updateOffset.value();
    },
    setWindow: { |self, newWindow|
      window = newWindow;
      updateWindow.value();
    },
    startAnimation: {
      started = true;
      updateTimeCursor = OSCFunc.new({ |msg|
        { view.timeCursorPosition = msg[3] }.defer;
      }, playheadOscAddr, s.addr);
    },
    stopAnimation: {
      started = false;
      updateTimeCursor.free;
    },
    toggleAnimation: { |self, input|
      var choice;
      if (input == nil,
        { choice = started.not },
        { choice = input }
      );
      if (choice,
        { self.startAnimation },
        { self.stopAnimation }
      )
    }
  )
}
