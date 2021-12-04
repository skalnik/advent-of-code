package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	fmt.Println("=== Part 1 ===")
	part1()

	fmt.Println("=== Part 2 ===")
	part2()
}

func part1() {
	file, err := os.Open("input/day1.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	var previous, increases int

	// Get first line
	scanner.Scan()
	previous, err = strconv.Atoi(scanner.Text())
	if err != nil {
		log.Fatal(err)
	}

	for scanner.Scan() {
		depth, err := strconv.Atoi(scanner.Text())

		if err != nil {
			log.Fatal(err)
		}

		if depth > previous {
			increases++
		}
		previous = depth
	}

	fmt.Println(increases)
}

func part2() {

}
