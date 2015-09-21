package ua.factory {
  public interface IXMLAttributeTransformer {
    function transform(name:String, value:String, current:Object, host:Object):Object;
  }
}
