package ua.factory {
  public interface IXMLAttributeHandler {
    function handle(name:String, value:String, current:Object, host:Object):Boolean;
  }
}
