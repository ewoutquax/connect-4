package main

import (
	"fmt"

	"github.com/ewoutquax/connect-4/internals/config"
	"github.com/ewoutquax/connect-4/internals/game"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/ewoutquax/connect-4/pkg/benchmark"
	"github.com/ewoutquax/connect-4/utils"
)

var bench *benchmark.Benchmark = benchmark.Singleton()

func main() {
	config.InitializeApp()

	var myGame *game.Game

	for {
		fmt.Println("Would you like to start? (y/n)")
		choice := (utils.StdinReaderDefault{}).StdinReaderExec()

		if choice == "y" {
			myGame = game.Building(
				game.WithPlayerRed(player.PlayerKindHuman),
				game.WithPlayerYellow(player.PlayerKindAI),
			)
		} else {
			myGame = game.Building(
				game.WithPlayerRed(player.PlayerKindAI),
				game.WithPlayerYellow(player.PlayerKindHuman),
			)
		}

		bench.Start("playGame")
		myGame.Play()
		bench.Stop("playGame")
		fmt.Println(bench.Report())
	}
}
