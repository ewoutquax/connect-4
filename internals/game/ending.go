package game

func (g *Game) IsEnded() bool {
	return g.Board.IsFull() || g.Board.IsWinner(g.CurrentPlayer.Chip)
}
