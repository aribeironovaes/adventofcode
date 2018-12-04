#pragma once

#include <vector>

#include <set>
#include <map>
#include <tuple>
#include <algorithm>
#include <iterator>

using namespace std; 

struct ClaimEntry {
	int id;
	int leftToSquare; 
	int topToSquare;
	int width;
	int height;
};

struct Claimed {
	bool visited;
	bool counted;
	vector<int> claimIds;
};

class Solution {
private:
	vector<vector<Claimed> > fabric;
public: 
	Solution() :fabric(2000, vector<Claimed>(2000, { false, false })) {};

	long doubleBookedSquareInches(vector<ClaimEntry>& entries) {
		long inchesSquareResult = 0;
		set<int> allClaims;
		set<int> intersecting;
		

		for (size_t i = 0; i < entries.size(); i++)
		{
			for (size_t j = 0; j < entries[i].width; j++)
			{
				for (size_t k = 0; k< entries[i].height; k++)
				{
					
					
					allClaims.insert(entries[i].id);
					fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].claimIds.push_back(entries[i].id);

					if (fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].visited == true &&
						fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].counted == false) {
						fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].counted = true;
						if (!fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].claimIds.empty()) {
							for (int m = 0; m < fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].claimIds.size(); m++)
							{
								intersecting.insert(fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].claimIds[m]);
							}
						}
						inchesSquareResult++;
						intersecting.insert(entries[i].id);
					} else {
						fabric[entries[i].leftToSquare + j][entries[i].topToSquare + k].visited = true;
					}					
				}
			}			
		}


		//Result set will contain the Difference between intersection and not intersecting.
		std::set<int> result;
		std::set_difference(allClaims.begin(), allClaims.end(), intersecting.begin(), intersecting.end(),
			std::inserter(result, result.end()));

		return inchesSquareResult;
	}
};
