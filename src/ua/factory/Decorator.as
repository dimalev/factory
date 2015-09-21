package ua.factory {
  /**
   * Adds unified effects and capabilities to Element.
   *
   * TODO: add onRemove callback to clean the object.
   */
  public class Decorator {
    private var mTarget:Object;

    public function get target():Object { return mTarget; }

    public function Decorator(trg:Object) {
      mTarget = trg;
    }

    public function onCommitProperties():void { "Implement ME!"; }

    public function onBeforeRedraw():void { "Implement ME!"; }
    public function onAfterRedraw():void { "Implement ME!"; }
  }
}
