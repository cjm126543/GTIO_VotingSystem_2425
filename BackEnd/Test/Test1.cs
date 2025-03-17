using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Test
{
    [TestClass] 
    public class SampleTests
    {
        [TestMethod] 
        public void Sum_TwoPlusTwo_ShouldReturnFour()
        {
            // Arrange
            int a = 2;
            int b = 2;

            // Act
            int result = a + b;

            // Assert
            Assert.AreEqual(4, result); // Comprobamos que 2 + 2 = 4
        }

        [TestMethod]
        public void String_ContainsWord_ShouldBeTrue()
        {
            // Arrange
            string phrase = "Hello, GitHub Actions!";

            // Act
            bool containsWord = phrase.Contains("GitHub");

            // Assert
            Assert.IsTrue(containsWord); // Comprobamos que la frase contiene "GitHub"
        }
    }
}
