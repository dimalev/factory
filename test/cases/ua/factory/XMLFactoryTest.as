package cases.ua.factory {
  import org.flexunit.Assert;

  import ua.factory.XMLFactory;

  public class XMLFactoryTest {
    [Test(description = "Lets start from the start")]
    public function simple():void {
        var xf:XMLFactory = new XMLFactory();
        xf.addTagHandler("sample", SampleClass);

        var o:Object = xf.decode(<sample lala="12" />);

        Assert.assertTrue("Should instanciate simple class", o is SampleClass);
        var sc:SampleClass = o as SampleClass;
        Assert.assertEquals("Should overload value by default", o.lala, 12);
    }
  }
}

class SampleClass {
    public var lala:int = 10;
}