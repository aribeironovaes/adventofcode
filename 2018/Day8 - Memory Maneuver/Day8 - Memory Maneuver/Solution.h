#pragma once

#include <list>
#include <vector>

using namespace std; 

class Solution {
public: 
	void sumMetadata(list<int>& input, int& acc) {
		int nchildren, nmeta;
		nchildren = input.front();
		input.pop_front();
		nmeta = input.front();
		input.pop_front();

		for (int i = 0; i < nchildren; i += 1) {
			sumMetadata(input, acc);
		}

		for (int i = 0; i < nmeta; i += 1) {
			int meta;

			meta = input.front();
			input.pop_front();
			acc += meta;
		}
	}


	int sumMetadata(list<int>& input) {
		int nchildren, nmeta;
		int resultReturn = 0;
		nchildren = input.front();
		input.pop_front();
		nmeta = input.front();
		input.pop_front();

		for (int i = 0; i < nchildren; i += 1) {
			sumMetadata(input, resultReturn);
		}

		for (int i = 0; i < nmeta; i += 1) {
			int meta;
			meta = input.front();
			input.pop_front();
			resultReturn += meta;
		}

		return resultReturn;
	}
};
