package main

import (
	"bufio"
	"os"
)

func main() {
	input, err := os.Open("input/day2.txt")
	if err != nil {
		os.Exit(1)
	}

	println("Part 1:", scorePart1(input))
	input.Seek(0, 0)
	println("Part 2:", scorePart2(input))
}

func scorePart1(file *os.File) int {
	var playScore = map[string]int{
		"X": 1,
		"Y": 2,
		"Z": 3,
	}

	var gameScore = map[string]map[string]int{
		"A": {
			"X": 3,
			"Y": 6,
			"Z": 0,
		},
		"B": {
			"X": 0,
			"Y": 3,
			"Z": 6,
		},
		"C": {
			"X": 6,
			"Y": 0,
			"Z": 3,
		},
	}
	score := 0

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	for scanner.Scan() {
		game := scanner.Text()
		player1 := game[0:1]
		player2 := game[2:3]
		score += playScore[player2] + gameScore[player1][player2]
	}

	return score
}

func scorePart2(file *os.File) int {
	var outcomeScore = map[string]int{
		"X": 0,
		"Y": 3,
		"Z": 6,
	}

	var playScore = map[string]map[string]int{
		"A": {
			"X": 3,
			"Y": 1,
			"Z": 2,
		},
		"B": {
			"X": 1,
			"Y": 2,
			"Z": 3,
		},
		"C": {
			"X": 2,
			"Y": 3,
			"Z": 1,
		},
	}
	score := 0

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	for scanner.Scan() {
		game := scanner.Text()
		player1 := game[0:1]
		outcome := game[2:3]
		score += outcomeScore[outcome] + playScore[player1][outcome]
	}

	return score
}
