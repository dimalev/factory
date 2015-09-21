package ua.factory {
  /**
   * Single tag handler. Implement this to custom parse special tags.
   */
  public interface IXMLTagHandler {
    /**
     * Decode single XML tag.
     *
     * @param data What to parse.
     * @param host Host object handling events and bindings.
     * @param el Suggested current element.
     * @param parent Parent of current element.
     * @param f Current XML factory.
     *
     * @returns Built element, or null, if tag is ephemeral.
     */
    function decode(data:XML, host:Object, el:Element, parent:Element, f:XMLFactory):Element;
  }
}