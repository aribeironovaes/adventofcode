#pragma once

#include <vector>
#include <map>

using namespace std; 

class Solution {
public: 
	int firstDoubleFrequency(vector<int> input) {
		map<int, bool> frequencies;
		int currentFrequency = 0;
		frequencies[currentFrequency] = true;
		bool foundDouble = false; 
		while (!foundDouble) {
			for (int i = 0; i < input.size(); i++)
			{
				currentFrequency += input[i];
				if (frequencies[currentFrequency] == true) {
					foundDouble = true;
					break;
				}
				frequencies[currentFrequency] = true;
			}
		}

		return currentFrequency;
	}
};
