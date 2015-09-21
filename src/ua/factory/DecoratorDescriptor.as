package ua.factory {
  public final class DecoratorDescriptor {
    private var mStyles:Vector.<String> = new Vector.<String>;
    private var mName:String;
    private var mProto:Class;

    public function get proto():Class { return mProto; }
    public final function get styles():Vector.<String> { return mStyles; }
    public final function get name():String { return mName; }

    public function DecoratorDescriptor(name:String, proto:Class, styles:Vector.<String>) {
      mName = name;
      mProto = proto;
      mStyles = styles;
    }

    public final function instanceFor(target:Object):Decorator {
      return new mProto(target) as Decorator;
    }
  }
}
