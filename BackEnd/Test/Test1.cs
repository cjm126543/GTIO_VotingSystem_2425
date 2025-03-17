namespace Test
{
    using System;
    using Xunit;
    using Xunit.Abstractions;

    public class MyTests
    {
        private readonly ITestOutputHelper _output;

        public MyTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void TestWithOutput()
        {
            _output.WriteLine("Este es un mensaje de prueba.");
            Assert.True(true);
        }
    }

}
