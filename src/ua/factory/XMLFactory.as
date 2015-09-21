package ua.factory {
  /**
   * XML parser and object builder.
   */
  public class XMLFactory implements IFactory {
    protected var mMapping:Object = {};
    protected var mDecorators:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
    protected var mAttributeTransformers:Vector.<IXMLAttributeTransformer> = new Vector.<IXMLAttributeTransformer>;
    protected var mAttributeHandlers:Vector.<IXMLAttributeHandler> = new Vector.<IXMLAttributeHandler>;
    protected var mCSS:CSSFactory = new CSSFactory;

    /**
     * CSS styles and classes provider.
     */
    public function get cssFactory():CSSFactory { return mCSS; }

    /**
     * Register attribute handler.
     *
     * @param ah XML Attribute handler.
     */
    public function addAttributeHandler(ah:IXMLAttributeHandler):void {
      mAttributeHandlers.push(ah);
    }

    /**
     * Register attribute transformer.
     *
     * @param at XML attribute transformer.
     */
    public function addAttributeTransformer(at:IXMLAttributeTransformer):void {
      mAttributeTransformers.push(at);
    }

    /**
     * Register tag handler by class representing it as UI Element.
     *
     * @param name tag name to handle.
     * @param cl Class to create.
     */
    public function addTagHandler(name:String, cl:Class):void {
      if(mMapping.hasOwnProperty(name))
        trace("[WARNING] Name is already occupied " + name + ": " + mMapping[name]);
      mMapping[name] = cl;
    }

    /**
     * Register decorator.
     *
     * @param d Decorator descriptor.
     */
    public function addDecorator(d:DecoratorDescriptor):void {
      if(mDecorators.indexOf(d) >= 0) return;
      mDecorators.push(d);
    }

    public function XMLFactory() {
      // addAttributeHandler(new HelpersHandler);
      // addAttributeHandler(new ContainerLayoutHandler);

      // addTagHandler("element", Element);
      // addTagHandler("box", BaseContainer);
    }

    private function merge(o1:Object, o2:Object):void {
      for(var k:String in o2)
        if(o2.hasOwnProperty(k) && !o1.hasOwnProperty(k)) o1[k] = o2[k];
    }

    public function decode(data:*, host:Object = null, el:Object = null):Object {
      if(!(data is XML)) {
        trace("XMLFactory can parse only xml. given: " + data);
        return el;
      }
      var xml:XML = data as XML;
      var tagName:String = xml.localName();
      var d:DecoratorDescriptor;
      var name:String;
      var nsname:String;
      var value:String;
      var cl:Class = name2class(tagName);
      if(null == el) {
        if(null == cl) {
          trace("[ERROR] XML factory create element: no such tag handler: " + tagName);
          return null;
        }
        el = new cl;
      } else if(!(el is cl)) trace("[WARNING] XML factory create element: type mismatch! Expected " + cl);

      var styles:Object = [];
      var dd:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
      var classes:Vector.<String> = null;
      for each(var attribute:XML in xml.attributes()) {
        name = attribute.localName();
        value = attribute.toString();
        if(name == "class") classes = Vector.<String>(value.split(" "));
        else styles[name] = value;
      }
      merge(styles, cssFactory.extraStylesFor(tagName, classes));

      var parsedStyles:Object = {};
      for(name in styles) {
        value = styles[name];
        var isHandled:Boolean = false;
        for each(var iat:IXMLAttributeTransformer in mAttributeTransformers) {
          var res:Object = iat.transform(name, value, el, host);
          if(!res) continue;
          name = res.newName;
          value = res.newValue;
          break;
        }
        for each(var iah:IXMLAttributeHandler in mAttributeHandlers) {
          if(iah.handle(name, value, el, host)) {
            isHandled = true;
            break;
          }
        }
        if(!isHandled) {
          for each(d in mDecorators) {
            if(d.styles.indexOf(name) < 0 && !(value == "on" && name == d.name)) continue;
            if(dd.indexOf(d) < 0) dd.push(d);
          }
          parsedStyles[name] = value;
        }
      }

      setStyles(el, parsedStyles);

      for each(d in dd) el.addDecorator(d.instanceFor(el));

      var index:int = 0;
      for each(var child:XML in xml.children()) {
          ++index;
          var e:Object = decode(child, host);
          if(e) addChild(el, e, index);
      }

      return el;
    }

    protected function setStyles(o:Object, styles:Object):void {
        for(var key:String in styles) o[key] = styles[key];
    }

    protected function addChild(parent:Object, child:Object, index:int):void {
        if(!(parent is IParent)) {
            trace("[Error] add child to not IParent instance");
            return;
        }
        (parent as IParent).addFactoryChild(child, index);
    }

    protected function name2class(tagName:String):Class {
      if(!mMapping.hasOwnProperty(tagName)) return null;
      return mMapping[tagName];
    }
  }
}
