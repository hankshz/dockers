package main

import (
	"encoding/json"
	"fmt"
	"os"
    "sort"
)

type Task struct {
	Loops int
    Items []int
    Type string
    Result []int
}

func main() {
	p := &Task{}
	json.NewDecoder(os.Stdin).Decode(p)
    p.Type = "go"
    for i := 0; i<p.Loops; i++ {
        p.Result = make([]int, len(p.Items))
        copy(p.Result, p.Items)
        sort.Ints(p.Result)
    }
    result, _ := json.Marshal(p)
	fmt.Println(string(result))
}
