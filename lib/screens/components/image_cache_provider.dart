import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Codec;
import '../../ffi.io.dart';
import 'images.dart';

class ImageCacheProvider extends ImageProvider<ImageCacheProvider> {
  final String url;
  final String useful;
  final double scale;
  final String? extendsFieldFirst;
  final String? extendsFieldSecond;
  final String? extendsFieldThird;

  ImageCacheProvider({
    required this.url,
    required this.useful,
    this.extendsFieldFirst,
    this.extendsFieldSecond,
    this.extendsFieldThird,
    this.scale = 1.0,
  });

  @override
  ImageStreamCompleter load(ImageCacheProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  @override
  Future<ImageCacheProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ImageCacheProvider>(this);
  }

  Future<ui.Codec> _loadAsync(ImageCacheProvider key) async {
    assert(key == this);
    return PaintingBinding.instance!.instantiateImageCodec(
      await _loadImageFile((await api.cacheImage(
        cacheKey: imageUrlToCacheKey(url),
        url: url,
        useful: useful,
        extendsFieldFirst: extendsFieldFirst,
        extendsFieldSecond: extendsFieldSecond,
        extendsFieldThird: extendsFieldThird,
      ))
          .absPath),
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final ImageCacheProvider typedOther = other;
    return url == typedOther.url && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType('
      'path: ${describeIdentity(url)},'
      ' scale: $scale'
      ')';
}

Future<Uint8List> _loadImageFile(String path) {
  return File(path).readAsBytes();
}
