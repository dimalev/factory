package ua.factory {
  /**
   * Operates with CSS.
   */
  public class CSSFactory {
    protected var mStyles:Vector.<Holder> = new Vector.<Holder>;

    public function CSSFactory() {
    }

    public function parse(styles:String):void {
      var records:Array = styles.split("}");
      for each(var record:String in records) {
        var cssd:Object = {};
        var parts:Array = record.split("{");
        if(parts.length != 2) continue;
        var namesStr:String = parts[0];
        var names:Array = namesStr.split(",");
        var filters:Vector.<CSSFilter> = new Vector.<CSSFilter>;
        for each(var name:String in names) {
          name = name.replace(/(^\s*|\s*$)/g, "");
          filters.push(CSSFilter.fromString(name));
        }
        var line:String = "";
        parts = parts[1].split(";");
        for each(var part:String in parts) {
          var values:Array = part.split(":");
          if(values.length != 2) continue;
          var style:String = values[0].replace(/(^\s*|\s*$)/g, "");
          var value:String = values[1].replace(/(^\s*|\s*$)/g, "");
          cssd[style] = value;
        }
        for each(var filter:CSSFilter in filters) mStyles.push(new Holder(filter, cssd));
      }
    }

    public function extraStylesFor(tagName:String, classNames:Vector.<String> = null):Object {
      var res:Object = {};
      for each(var h:Holder in mStyles) {
        if(h.filter.match(tagName, classNames)) {
          for(var name:String in h.styles)
            if(h.styles.hasOwnProperty(name)) {
              res[name] = h.styles[name];
            }
        }
      }
      return res;
    }
  }
}

import ua.factory.CSSFilter;

class Holder {
  public var filter:CSSFilter;
  public var styles:Object;

  public function Holder(filter:CSSFilter, styles:Object) {
    this.filter = filter;
    this.styles = styles;
  }
}