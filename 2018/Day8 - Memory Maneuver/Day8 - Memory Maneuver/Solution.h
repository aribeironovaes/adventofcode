#pragma once

#include <list>

using namespace std; 

class Solution {
private: 

	long sumFrontMetadataEntries(list<int>& input, int entriesNumber) {
		long sum = 0;
		for (size_t i = 0; i < entriesNumber; i++)
		{
			sum += input.front();
			input.pop_front();
		}
		return sum;
	}

	long sumBackMetadataEntries(list<int>& input, int entriesNumber) {
		long sum = 0;
		for (size_t i = 0; i < entriesNumber; i++)
		{
			sum += input.back();
			input.pop_back();
		}
		return sum; 
	}

	void sumMetadata(list<int>& input, int numOfChilds, long& acc) {
		
		int currentItemMetadata = input.front();
		input.pop_front();

		if (numOfChilds == 0) {
			acc += sumFrontMetadataEntries(input, currentItemMetadata);
			//Get the number of metadata and sum metadata. 
		}
		else {
			//Get the number of metadata from the end of the list and call with the next item. 
			acc += sumBackMetadataEntries(input, currentItemMetadata);			
		}

		if (input.empty()) {
			return; //Finished.
		}
		int numberOfChildsOfFirstItem = input.front();
		input.pop_front();
		sumMetadata(input, numberOfChildsOfFirstItem, acc);

	}
public: 
	int sumMetadata(list<int>& input) {
		long returnResult = 0;
		if (!input.empty()) {
			int numberOfChildsOfFirstItem = input.front();
			input.pop_front();
			//First thing to do is to create the recursive call, passing all the info. 
			sumMetadata(input, numberOfChildsOfFirstItem, returnResult);

		}

		return returnResult;
	};
};
