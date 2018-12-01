#pragma once

#include <vector>

using namespace std; 

class Solution {
public: 
	int frequencyCalculator(vector<int> frequencies) {
		int returnValue = 0;
		for (int i = 0; i < frequencies.size(); i++)
		{
			returnValue += frequencies[i];
		}

		return returnValue; 
	}
};
