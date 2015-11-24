library html_assembler;

import 'package:barback/barback.dart' show Asset, Transform, Transformer;
import 'dart:async' show Future;
import 'package:html/parser.dart' show parse;
import 'package:code_transformers/assets.dart' show uriToAssetId;

/// Imports html fragments into the referencing div.
/// reference a fragment with the import="path" attribute
class HtmlAssemblerTransformer extends Transformer {
  HtmlAssemblerTransformer.asPlugin();

  String get allowedExtensions => ".html";

  Future apply(Transform transform) {
    var id = transform.primaryInput.id;
    return transform.primaryInput.readAsString().then((content) {
      var document = parse(content);

      // attribute selectors are not implemented
      var processing = document.querySelectorAll('div').where((tag) {
        return tag.attributes['import'] != null;
      }).map((tag) {
        var src = tag.attributes['import'];
        var srcAssetId = uriToAssetId(id, src, transform.logger, tag.sourceSpan);

        return transform.readInputAsString(srcAssetId).then((source) {
          tag.innerHtml = source;
          tag.attributes.remove('import');
        });
      });

      return Future.wait(processing).then((_) {
        transform.addOutput(new Asset.fromString(id, document.outerHtml));
      });
    });
  }
}