#pragma once

#include <list>
#include <vector>

using namespace std; 



class MarbleMania {
private:

	// Structure of a Node 
	struct Node
	{
		int data;
		struct Node *next;
		struct Node *prev;
	};

	// Function to insert at the end 
	void insertEnd(struct Node** start, int value)
	{
		// If the list is empty, create a single node 
		// circular and doubly list 
		if (*start == NULL)
		{
			struct Node* new_node = new Node;
			new_node->data = value;
			new_node->next = new_node->prev = new_node;
			*start = new_node;
			return;
		}

		// If list is not empty 

		/* Find last node */
		Node *last = (*start)->prev;

		// Create Node dynamically 
		struct Node* new_node = new Node;
		new_node->data = value;

		// Start is going to be next of new_node 
		new_node->next = *start;

		// Make new node previous of start 
		(*start)->prev = new_node;

		// Make last preivous of new node 
		new_node->prev = last;

		// Make new node next of old last 
		last->next = new_node;
	}

	// Function to insert Node at the beginning 
	// of the List, 
	void insertBegin(struct Node** start, int value)
	{
		// Pointer points to last Node 
		struct Node *last = (*start)->prev;

		struct Node* new_node = new Node;
		new_node->data = value;   // Inserting the data 

		// setting up previous and next of new node 
		new_node->next = *start;
		new_node->prev = last;

		// Update next and previous pointers of start 
		// and last. 
		last->next = (*start)->prev = new_node;

		// Update start pointer 
		*start = new_node;
	}

	// Function to insert node with value as value1. 
	// The new node is inserted after the node with 
	// with value2 
	void insertAfter(struct Node** start, int value1,
		int value2)
	{
		struct Node* new_node = new Node;
		new_node->data = value1; // Inserting the data 

		// Find node having value2 and next node of it 
		struct Node *temp = *start;
		while (temp->data != value2)
			temp = temp->next;
		struct Node *next = temp->next;

		// insert new_node between temp and next. 
		temp->next = new_node;
		new_node->prev = temp;
		new_node->next = next;
		next->prev = new_node;
	}

	int numberOfPlayer; 
	int lastMarbleValue;

	/* Start with the empty list */
	struct Node* currentMarble = NULL;


	vector<unsigned long long> playersScores;

	int currentPlayer; 
	int nextMarbleValue;

	void playRound() {
		if (nextMarbleValue % 23 == 0) {
			playersScores[currentPlayer] += nextMarbleValue;
			playersScores[currentPlayer] += removeItemToPosition7BeforeCurrentAndUpdateCurrent();
			if (currentPlayer == playersScores.size() - 1) {
				currentPlayer = 0;
			}
			else {
				currentPlayer++;
			}
		}
		else {
			addItemToPosition1AfterCurrent();
			if (currentPlayer == playersScores.size() -1) {
				currentPlayer = 0;
			}
			else {
				currentPlayer++;
			}			
		}
	}

	int removeItemToPosition7BeforeCurrentAndUpdateCurrent() {
		int returnValue = -1;
		nextMarbleValue++;

		struct Node *temp = currentMarble;

		int count = 7;
		struct Node *next = NULL;
		while (count > 0) {
			temp = temp->prev;
			struct Node *next = temp->next;
			count--;
		}


		// remove this node, getting the value to return. 
		returnValue = temp->data;
		//Update Current.
		currentMarble = temp->next;

		
		temp->prev->next = temp->next;
		temp->next->prev = temp->prev;

		delete temp;

		return returnValue;
	}

	void addItemToPosition1AfterCurrent() {
		struct Node* new_node = new Node;
		new_node->data = nextMarbleValue; // Inserting the data 
		nextMarbleValue++;

		struct Node *temp = currentMarble;
		
		temp = temp->next;
		struct Node *next = temp->next;

		// insert new_node between temp and next. 
		temp->next = new_node;
		new_node->prev = temp;
		new_node->next = next;
		next->prev = new_node;

		currentMarble = new_node;
	}

public: 
	MarbleMania(int numberOfPlayer, int lastMarbleValue) : numberOfPlayer(numberOfPlayer), lastMarbleValue(lastMarbleValue){
		/* Start with the empty list */
		insertEnd(&currentMarble, 0);
		currentPlayer = 0;
		nextMarbleValue = 1;
		playersScores.resize(numberOfPlayer);
	};



	unsigned long long playGame() {

		while (nextMarbleValue <= lastMarbleValue) {
			playRound();
		}

		//Game is over, identify winner.
		unsigned long long maxScore = 0;
		for (size_t i = 0; i < playersScores.size(); i++)
		{
			if (playersScores[i] > maxScore) {
				maxScore = playersScores[i];
			}
		}
		//While last marble was not put, keep playing Rounds. 
		return maxScore; 
	}
};
