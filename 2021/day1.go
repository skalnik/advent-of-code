package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
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
	contents, err := ioutil.ReadFile("input/day1.txt")
	if err != nil {
		log.Fatal(err)
	}

	lines := strings.Split(string(contents), "\n")
	var depths []int
	var a, b, c, sums []int

	for i := 0; i < len(lines); i++ {
		if lines[i] == "" {
			break
		}
		depth, err := strconv.Atoi(lines[i])
		if err != nil {
			log.Fatal(err)
		}

		depths = append(depths, depth)
	}

	a = depths[2:]
	b = depths[1 : len(depths)-1]
	c = depths[:len(depths)-2]

	for i := 0; i < len(a); i++ {
		sums = append(sums, a[i]+b[i]+c[i])
	}

	increases := 0
	previous := sums[0]
	for i := 1; i < len(sums); i++ {
		if sums[i] > previous {
			increases++
		}
		previous = sums[i]
	}

	fmt.Println(increases)
}
