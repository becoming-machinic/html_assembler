library html_assembler;

import 'package:barback/barback.dart' show Asset, Transform, Transformer;
import 'dart:async' show Future;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Node;
import 'package:code_transformers/assets.dart' show uriToAssetId;

/// Imports html fragments into the referencing div.
/// reference a fragment with the import="path" attribute
class HtmlAssemblerTransformer extends Transformer {
  final BarbackSettings _settings;
  HtmlAssemblerTransformer.asPlugin(this._settings);

  String get allowedExtensions => ".html";

  Future apply(Transform transform) {
    var id = transform.primaryInput.id;

    transform.logger.info("Processing file $id");
    return transform.primaryInput.readAsString().then((content) {
      var document = parse(content);

      var processing = document.querySelectorAll("[import]").where((tag) {
        return tag.attributes['import'].isNotEmpty;
      }).map((tag) {
        var src = tag.attributes['import'];
        var srcAssetId = uriToAssetId(id, src, transform.logger, tag.sourceSpan,errorOnAbsolute:false);
        transform.logger.info("Importing " + srcAssetId.path);

        return transform.readInputAsString(srcAssetId).then((source) {
          tag.innerHtml = source;
          tag.attributes.remove('import');
        });
      });

      return Future.wait(processing).then((_) {
        if (_settings.mode.name == 'debug')
          transform.addOutput(new Asset.fromString(id, document.outerHtml));
        else{
          RegEx commentPattern = new RegExp(r"^\s*<!-[-]\s+.*\s[-]+->\s*$",multiLine:true);
          transform.addOutput(new Asset.fromString(id, document.outerHtml.replaceAll(commentPattern,"")));
        }
      });
    });
  }
}