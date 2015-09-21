package ua.factory {
  /**
   * Object filter.
   */
  public class CSSFilter {
    public static function fromString(str:String):CSSFilter {
      var parts:Object = /(?<tagName>[-\w\d]+)?(\.(?<cssName>[-\w\d]+))?/.exec(str);
      return new CSSFilter(parts[1], parts[3]);
    }

    public var tagName:String;
    public var className:String;
    public function CSSFilter(tagName:String,
                              className:String = null) {
      this.tagName = tagName;
      this.className = className;
    }

    public function match(tagName:String, classNames:Vector.<String> = null):Boolean {
      if(this.className) {
        if(!classNames) return false;
        if(classNames.indexOf(this.className) < 0) return false;
      }
      if(this.tagName && this.tagName != tagName) return false;
      return true;
    }
  }
}