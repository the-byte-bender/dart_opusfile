import "dart:ffi";
import "./opusfile_generated_bindings.dart";
import "./opus_file.dart";

class Opus {
  final OpusfileBindings _bindings;
  Opus.fromDynamicLibrary(DynamicLibrary lib)
      : _bindings = OpusfileBindings(lib);
  Opus(String vorbisfileLibraryPath)
      : this.fromDynamicLibrary(DynamicLibrary.open(vorbisfileLibraryPath));
  OpusFile decodeFile(String path) => OpusFile(_bindings, path);
}
