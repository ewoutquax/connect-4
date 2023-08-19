package main

import (
	"fmt"

	"github.com/ewoutquax/connect-4/internals/game"
	"github.com/ewoutquax/connect-4/internals/player"
	"github.com/ewoutquax/connect-4/utils"
)

func main() {
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
				game.WithPlayerRed(player.PlayerKindHuman),
				game.WithPlayerYellow(player.PlayerKindAI),
			)
		}

		myGame.Play()
	}
}
