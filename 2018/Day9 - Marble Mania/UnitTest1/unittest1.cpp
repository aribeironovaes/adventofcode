#include "stdafx.h"
#include "CppUnitTest.h"

#include "MarbleMania.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTest1
{		
	TEST_CLASS(UnitTest1)
	{
	public:
		
		TEST_METHOD(TestMethod1)
		{
			//Arrange
			MarbleMania game_instance(9, 25);
			long double expectedOutput = 32;

			//Act
			long double realOutput = game_instance.playGame();

			//Assert
			Assert::IsTrue(expectedOutput == realOutput);
		}

		TEST_METHOD(TestMethod2)
		{
			//Arrange
			MarbleMania game_instance(10, 1618);
			long double expectedOutput = 8317;

			//Act
			long double realOutput = game_instance.playGame();

			//Assert
			Assert::IsTrue(expectedOutput == realOutput);
		}

		TEST_METHOD(TestMethod3)
		{
			//Arrange
			MarbleMania game_instance(13, 7999);
			long double expectedOutput = 146373;

			//Act
			long double realOutput = game_instance.playGame();

			//Assert
			Assert::IsTrue(expectedOutput == realOutput);
		}

		TEST_METHOD(RealGame)
		{
			//Arrange
			MarbleMania game_instance(418, 71339);
			long double expectedOutput = 412127;

			//Act
			long double realOutput = game_instance.playGame();

			//Assert
			Assert::IsTrue(expectedOutput == realOutput);
		}

		TEST_METHOD(RealGameLastTimes100)
		{
			//Arrange
			MarbleMania game_instance(418, 7133900);
			unsigned long long expectedOutput = 412127;

			//Act
			unsigned long long realOutput = game_instance.playGame();

			//Assert
			Assert::AreEqual(expectedOutput, realOutput);
		}
	};
}