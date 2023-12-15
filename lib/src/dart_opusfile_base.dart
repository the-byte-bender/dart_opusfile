import "dart:ffi";
import "./opusfile_generated_bindings.dart";
import "./opus_file.dart";

/// The opusfile bindings.
class Opus {
  final OpusfileBindings _bindings;
  Opus.fromDynamicLibrary(DynamicLibrary lib)
      : _bindings = OpusfileBindings(lib);

  /// Initialize the bindings with a [path] to the opusfile shared library.
  Opus(String vorbisfileLibraryPath)
      : this.fromDynamicLibrary(DynamicLibrary.open(vorbisfileLibraryPath));

  /// Decodes a file. See [OpusFile] for more details
  OpusFile decodeFile(String path) => OpusFile(_bindings, path);
}
