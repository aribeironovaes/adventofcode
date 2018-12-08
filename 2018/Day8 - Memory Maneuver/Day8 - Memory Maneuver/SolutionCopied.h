#pragma once

#include <iostream>
#include <memory>
#include <numeric>
#include <stdexcept>
#include <vector>

struct node {
	std::vector<int> metadata;
	std::vector<std::unique_ptr<node>> children;
	node(int nmeta, int nchildren) {
		metadata.reserve(nmeta);
		children.reserve(nchildren);
	}
};

std::unique_ptr<node> read_metadata(std::istream &in) {
	int nchildren, nmeta;

	if (!(in >> nchildren >> nmeta)) {
		throw std::runtime_error{ "Input failed!" };
	}

	auto n = std::make_unique<node>(nchildren, nmeta);

	for (int i = 0; i < nchildren; i += 1) {
		n->children.push_back(read_metadata(in));
	}

	for (int i = 0; i < nmeta; i += 1) {
		int meta;
		if (!(in >> meta)) {
			throw std::runtime_error{ "Input of metadata failed!" };
		}
		n->metadata.push_back(meta);
	}

	return n;
}

int count_metadata(const std::unique_ptr<node> &n) {
	int metadata = 0;
	for (const auto &c : n->children) {
		metadata += count_metadata(c);
	}
	metadata += std::accumulate(n->metadata.begin(), n->metadata.end(), 0);
	return metadata;
}

int value_of(const std::unique_ptr<node> &n) {
	if (n->children.empty()) {
		return std::accumulate(n->metadata.begin(), n->metadata.end(), 0);
	}

	int val = 0;
	for (auto c : n->metadata) {
		if (static_cast<std::vector<int>::size_type>(c) > n->children.size()) {
			continue;
		}
		val += value_of(n->children[c - 1]);
	}
	return val;
}