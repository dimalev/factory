package ua.factory {
  /**
   * Basic configurable interface for building user interface.
   */
  public interface IFactory {
    function decode(data:*, host:Object = null, el:Object = null):Object;
  }
}
