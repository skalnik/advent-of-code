package main

import (
	"bufio"
	"os"
	"sort"
	"strconv"
)

func main() {
	input, err := os.Open("input/day1.txt")
	if err != nil {
		os.Exit(1)
	}

	calories := parseCalories(input)
	println("Part 1:", maxCalorie(calories))
	println("Part 2:", sumOfTopThree(calories))
}

func parseCalories(file *os.File) []int {
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)
	var calories []int
	currentCalories := 0

	for scanner.Scan() {
		calorie, err := strconv.ParseInt(scanner.Text(), 10, 32)
		if err != nil { // Blank line
			calories = append(calories, currentCalories)
			currentCalories = 0
		} else {
			currentCalories += int(calorie)
		}
	}

	return calories
}

func maxCalorie(calories []int) int {
	slice := calories[:]
	sort.Ints(slice)

	return slice[len(slice)-1]
}

func sumOfTopThree(calories []int) int {
	slice := calories[:]
	sort.Ints(slice)

	return slice[len(slice)-1] + slice[len(slice)-2] + slice[len(slice)-3]
}
