package main

import (
	"bufio"
	"os"
	"strings"
)

func main() {
	var input *os.File
	var err error

	if len(os.Args[1:]) > 0 {
		input, err = os.Open("test/day3.txt")
	} else {
		input, err = os.Open("input/day3.txt")
	}

	if err != nil {
		os.Exit(1)
	}

	scoreValue("A")
	scoreValue("Z")
	scoreValue("a")
	scoreValue("z")
	println("Part 1: ", partOne(input))
	input.Seek(0, 0)
	println("Part 1: ", partTwo(input))
}

func partOne(file *os.File) int {
	score := 0
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	for scanner.Scan() {
		rucksack := scanner.Text()
		packages := strings.SplitAfter(rucksack, "")
		middle := len(packages) / 2
		one := packages[0:middle]
		two := packages[middle:]

		for _, charOne := range one {
			for _, charTwo := range two {
				if charOne == charTwo {
					println(charOne, scoreValue(charOne))
					score += scoreValue(charOne)
				}
			}
		}
	}

	return score
}

func partTwo(file *os.File) int {
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	for scanner.Scan() {
	}

	return 0
}

func scoreValue(char string) int {
	value := int([]rune(char)[0])

	if char == strings.ToUpper(char) {
		return value - 38
	} else {
		return value - 96
	}
}
