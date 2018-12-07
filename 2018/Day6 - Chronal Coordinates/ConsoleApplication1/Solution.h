#pragma once
#include <vector>
#include <limits>
#include <algorithm>
#include <iostream>
#include <list>
#include <map>

using namespace std; 

struct Point {
	int ID;
	int CloserCollumn; 
	int CloserRow;

	Point() : ID('.'), CloserCollumn(0), CloserRow(0) {};

	Point(int id , int closerX, int closerY) : ID(id), CloserCollumn(closerX), CloserRow(closerY) {};
};

class Solution {
private:
	vector<vector<Point>> matrix;
	vector<Point> points; 

	int distanceBetweenPoints(Point p1, Point p2) {

	}

	Point checkProximity(int row, int collumn, vector<Point> points) {
		list<Point> closerPoints; 
		Point returnPoint; //Default ReturnPoint
		int minDistance = INT_MAX;

		for (size_t i = 0; i < points.size(); i++)
		{
			int distance = abs(points[i].CloserCollumn - collumn) + abs(points[i].CloserRow - row);

			if (distance < minDistance) {
				minDistance = distance;
				closerPoints.clear();
				closerPoints.push_back(points[i]);
			}
			else if (distance == minDistance) {
				closerPoints.clear();
			}
		}

		if (closerPoints.empty()) {
			Point defaultPoint; 
			returnPoint = defaultPoint;
		}
		else {
			returnPoint = closerPoints.front();
		}

		return returnPoint;
	};

public: 
	void buildMatrix(vector<Point> inputPoints) {
		//First discover the the lower x, lower y, higher x and higher y.
		//With that we can plot the numbers on the Matrix following an offset, so we start at point 0.0. 
		//int lowerCollumn = INT_MAX;
		//int lowerRow = INT_MAX;
		this->points = inputPoints;
		int maxx = INT_MIN;
		int maxy = INT_MIN;

		for (size_t i = 0; i < inputPoints.size(); i++)
		{
			//lowerCollumn = min(inputPoints[i].CloserCollumn, lowerCollumn);
			//lowerRow = min(inputPoints[i].CloserRow, lowerRow);
			maxx = max(inputPoints[i].CloserCollumn, maxx);
			maxy = max(inputPoints[i].CloserRow, maxy);
		}
		//this->offsetCollumn = lowerCollumn;
		//this->offsetRow = lowerRow;
		matrix.resize(maxy+1);
		for (size_t i = 0; i < matrix.size(); i++)
		{
			matrix[i].resize(maxx+1);
		}
	}

	void printMatrix() {
		//Print matrix
		for (size_t i = 0; i < matrix.size(); i++)
		{
			for (size_t j = 0; j < matrix[i].size(); j++)
			{
				cout << matrix[i][j].ID << " ";
			}
			cout << endl;
		}
	}

	//This will check each point of the matrix and get which referent point is is closer and paint it. 
	int paintMatrixReturnBiggerLimitedIslandCount() {
		map<int, int> PointsAmount;
		for (size_t i = 0; i < matrix.size(); i++)
		{
			for (size_t j = 0; j < matrix[0].size(); j++)
			{
				//For all Item int he matrix check if the item is closer to which point. 
				Point finalPoint = checkProximity(i, j, this->points);
				PointsAmount[finalPoint.ID]++;
				matrix[i][j] = finalPoint;
			}
		}
		map<int, int>::iterator it;

		//To finish the first part, we gotta remove from the map the points that is on the limit. 
		//Check first line. 
		int matrixSize = matrix.size();
		for (size_t i = 0; i < matrix[0].size(); i++)
		{
			PointsAmount[matrix[0][i].ID] = 0;
			PointsAmount[matrix[matrixSize -1][i].ID] = 0;
		}

		int matrixCollumnsSize = matrix[0].size();
		for (size_t i = 0; i < matrix.size(); i++)
		{
			PointsAmount[matrix[i][0].ID] = 0;
			PointsAmount[matrix[i][matrixCollumnsSize - 1].ID] = 0;
		}

		int maxAmount = INT_MIN;
		char selectedIsland = '.';
		//At this point I have a map with the amount if item. Iterate and find the biggest one. 
		for (it = PointsAmount.begin(); it != PointsAmount.end(); it++)
		{
			if (maxAmount < it->second) {
				maxAmount = it->second;
				selectedIsland = it->first;
				std::cout << "Selected: " << it->first  // (key)
					<< ':'
					<< it->second   // string's value 
					<< std::endl;
			}			
		}

		return maxAmount;
	}

	bool isSafeZone(int row, int collumn, vector<Point> points, int maxRadio) { 

		int totalDistance = 0;
		for (size_t i = 0; i < points.size(); i++)
		{
			int distance = abs(points[i].CloserCollumn - collumn) + abs(points[i].CloserRow - row);
			
			totalDistance += distance;

			if (totalDistance >= maxRadio) {
				return false; 
			}
		}

		return true; 
	}

	int calculateSafeRegion(int radio) {
		int size = 0;

		for (size_t i = 0; i < matrix.size(); i++)
		{
			for (size_t j = 0; j < matrix[0].size(); j++)
			{
				if (isSafeZone(i, j, this->points, radio)) {
					size++;
				}
			}			
		}

		return size; 
	}
};
