# File: dtree.py
#    from chapter 3 of _Tree-based Machine Learning Algorithms_
#
# Author: Clinton Sheppard <fluentcoder@gmail.com>
# Copyright (c) 2017 Clinton Sheppard
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.  See the License for the specific language governing
# permissions and limitations under the License.

from numbers import Number
import operator
import math


def build(data, outcomeLabel, continuousAttributes=None):

    attrIndexes = [index for index, label in enumerate(data[0]) if label != outcomeLabel]
    print( "attrIndexes: " + str(attrIndexes) )

    outcomeIndex = data[0].index(outcomeLabel)
    print( "outcomeIndex: " + str(outcomeIndex) )

    continuousAttrIndexes = set()
    if continuousAttributes is not None:
        continuousAttrIndexes = {data[0].index(label) for label in continuousAttributes}
        if len(continuousAttrIndexes) != len(continuousAttributes):
            raise Exception('One or more continuous column names are duplicates.')
    else:
        for attrIndex in attrIndexes:
            uniqueValues  = {row[attrIndex] for rowIndex, row in enumerate(data) if rowIndex > 0}
            numericValues = {value for value in uniqueValues if isinstance(value, Number)}
            if len(uniqueValues) == len(numericValues):
                continuousAttrIndexes.add(attrIndex)
    print( "continuousAttrIndexes: " + str(continuousAttrIndexes) )

    nodes = []
    lastNodeNumber = 0

    workQueue = [ (-1, lastNodeNumber, set(i for i in range(1, len(data)))) ]
    while len(workQueue) > 0:

        print( "~~~~~~~~~~" )

        parentNodeId, nodeId, dataRowIndexes = workQueue.pop()
        print(
            "parentNodeId: "   + str(parentNodeId)        + ", " +
            "nodeId: "         + str(nodeId)              + ", " +
            "dataRowIndexes: " + str(dataRowIndexes)
            )

        uniqueOutcomes = set(data[i][outcomeIndex] for i in dataRowIndexes)
        if len(uniqueOutcomes) == 1:
            nodes.append((nodeId, uniqueOutcomes.pop()))
            continue

        potentials = _get_potentials(
            attrIndexes           = attrIndexes,
            continuousAttrIndexes = continuousAttrIndexes,
            data                  = data,
            dataRowIndexes        = dataRowIndexes,
            outcomeIndex          = outcomeIndex
            )

        attrIndex, attrValue, isMatch = potentials[0][1:]
        print(
            "attrIndex: " + str(attrIndex) + ", " +
            "attrValue: " + str(attrValue) + ", " +
            "isMatch: "   + str(isMatch)
            )

        matches = {
            rowIndex for rowIndex in dataRowIndexes
            if isMatch(data[rowIndex][attrIndex],attrValue)
            }

        nonMatches = dataRowIndexes - matches

        lastNodeNumber += 1
        matchId = lastNodeNumber
        workQueue.append((nodeId, matchId, matches))
        print( "    match: " + str( (nodeId, matchId, matches) ) )

        lastNodeNumber += 1
        nonMatchId = lastNodeNumber
        workQueue.append((nodeId, nonMatchId, nonMatches))
        print( "non-match: " + str( (nodeId, nonMatchId, nonMatches) ) )

        nodes.append(
            (nodeId, attrIndex, attrValue, isMatch, matchId, nonMatchId, len(matches), len(nonMatches))
            )

    print( "~~~~~~~~~~" )
    nodes = sorted(nodes, key = lambda n: n[0])
    return DTree(nodes, data[0])


def _get_potentials(
    attrIndexes,
    continuousAttrIndexes,
    data,
    dataRowIndexes,
    outcomeIndex
    ):

    uniqueAttributeValuePairs = {
        (attrIndex, data[rowIndex][attrIndex], operator.eq)
        for attrIndex     in attrIndexes
        if  attrIndex not in continuousAttrIndexes
        for rowIndex      in dataRowIndexes
        }
    print( "uniqueAttributeValuePairs: " + str(uniqueAttributeValuePairs) )
    print( "len(uniqueAttributeValuePairs) = " + str(len(uniqueAttributeValuePairs)) )
    print()

    continuousAttributeValuePairs = _get_continuous_av_pairs(
        continuousAttrIndexes,
        data,
        dataRowIndexes
        )
    print( "continuousAttributeValuePairs: " + str(continuousAttributeValuePairs) )
    print( "len(continuousAttributeValuePairs) = " + str(len(continuousAttributeValuePairs)) )
    print()

    uniqueAttributeValuePairs |= continuousAttributeValuePairs
    print( "uniqueAttributeValuePairs: " + str(uniqueAttributeValuePairs) )
    print( "len(uniqueAttributeValuePairs) = " + str(len(uniqueAttributeValuePairs)) )
    print()

    potentials = sorted(
        (-_get_bias(avPair, dataRowIndexes, data, outcomeIndex), avPair[0], avPair[1], avPair[2])
        for avPair in uniqueAttributeValuePairs
        )
    print( "potentials: " + str(potentials) )
    print( "len(potentials) = " + str(len(potentials)) )
    print()

    return potentials


def _get_continuous_av_pairs(continuousAttrIndexes, data, dataRowIndexes):
    avPairs = set()
    for attrIndex in continuousAttrIndexes:
        sortedAttrValues = [i for i in sorted(data[rowIndex][attrIndex] for rowIndex in dataRowIndexes)]
        indexes = _get_discontinuity_indexes(
            sortedAttrValues = sortedAttrValues,
            maxIndexes = max(
                math.sqrt(len(sortedAttrValues)),
                min(10,len(sortedAttrValues))
                )
            )
        for index in indexes:
            avPairs.add((attrIndex, sortedAttrValues[index], operator.gt))
    return avPairs


def _get_discontinuity_indexes(sortedAttrValues, maxIndexes):
    indexes = []
    for i in _generate_discontinuity_indexes_center_out(sortedAttrValues):
        indexes.append(i)
        if len(indexes) >= maxIndexes:
            break
    return indexes


def _generate_discontinuity_indexes_center_out(sortedAttrValues):
    # print( "sortedAttrValues: " + str(sortedAttrValues) )
    center = len(sortedAttrValues) // 2
    left  = center - 1
    right = center + 1
    while left >= 0 or right < len(sortedAttrValues):
        if left >= 0:
            if sortedAttrValues[left] != sortedAttrValues[left + 1]:
                #print(
                #    "center: " + str(center) + ", " +
                #    "left: "   + str(left)   + ", " +
                #    "right: "  + str(right)  + "; " +
                #    "yield: "  + str(left)
                #    )
                yield left
            left -= 1
        if right < len(sortedAttrValues):
            if sortedAttrValues[right - 1] != sortedAttrValues[right]:
                #print(
                #    "center: " + str(center) + ", " +
                #    "left: "   + str(left)   + ", " +
                #    "right: "  + str(right)  + "; " +
                #    "yield: "  + str(right - 1)
                #    )
                yield right - 1
            right += 1


def _get_bias(avPair, dataRowIndexes, data, outcomeIndex):

    attrIndex, attrValue, isMatch = avPair

    matchIndexes = {i for i in dataRowIndexes if isMatch(data[i][attrIndex], attrValue)}
    nonMatchIndexes = dataRowIndexes - matchIndexes

    matchOutcomes = {data[i][outcomeIndex] for i in matchIndexes}
    nonMatchOutcomes = {data[i][outcomeIndex] for i in nonMatchIndexes}

    numPureRows =   (len(matchIndexes)    if len(   matchOutcomes) == 1 else 0) \
                  + (len(nonMatchIndexes) if len(nonMatchOutcomes) == 1 else 0)

    percentPure = numPureRows / len(dataRowIndexes)

    numNonPureRows = len(dataRowIndexes) - numPureRows
    percentNonPure = 1 - percentPure

    split = 1 - abs(len(matchIndexes) - len(nonMatchIndexes)) / len(dataRowIndexes) - .001
    splitBias = split * percentNonPure if numNonPureRows > 0 else 0

    return splitBias + percentPure


class DTree:
    def __init__(self, nodes, attrNames):
        self._nodes = nodes
        self._attrNames = attrNames

    @staticmethod
    def _is_leaf(node):
        return len(node) == 2

    def __str__(self):
        s = ''
        for node in self._nodes:
            if self._is_leaf(node):
                s += '{}: {}\n'.format(node[0], node[1])
            else:
                nodeId, attrIndex, attrValue, isMatch, nodeIdIfMatch, \
                    nodeIdIfNonMatch, matchCount, nonMatchCount = node
                s += '{0}: {1}{7}{2}, {5} Yes->{3}, {6} No->{4}\n'.format(
                    nodeId, self._attrNames[attrIndex], attrValue,
                    nodeIdIfMatch, nodeIdIfNonMatch, matchCount,
                    nonMatchCount, '=' if isMatch == operator.eq else '>')
        return s

    def get_prediction(self, data):
        currentNode = self._nodes[0]
        while True:
            if self._is_leaf(currentNode):
                return currentNode[1]
            nodeId, attrIndex, attrValue, isMatch, nodeIdIfMatch, \
                nodeIdIfNonMatch = currentNode[:6]
            currentNode = self._nodes[nodeIdIfMatch if
                isMatch(data[attrIndex], attrValue) else nodeIdIfNonMatch]

