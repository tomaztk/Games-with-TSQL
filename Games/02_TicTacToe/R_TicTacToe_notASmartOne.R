# Not a smart AI Tic-Tac-Toe
#1. Draw tic-tac-toe board.
# 2. Add a playing loop and a board variable.
# 3. Alternate player ("X", "O") and require move on empty.
# 4. Check for win.
# 5. Add random computer player.
rm(list=ls()) # clear all defined objects

# Return whether player has 3 in a row on board.
won = function(board, player) {
  for (row in 1:3) {
    if (sum(board[row, ] == player) == 3) { # win in row
      return(TRUE)
    }
  }
  # ... check the 3 columns
  # ... check the two 2 diagonals
  return(FALSE)
}
# Here are a few test cases. Add a few more.
board = matrix(c("X","O","E","X","O","E","X","E","E"),
               nrow=3, ncol=3)
stopifnot( won(board, "X"))
stopifnot(!won(board, "O"))

# ---------- Here's the main program ----------
par(pty="s") # square plot type
x = rep(1:3, each = 3)
y = rep(1:3, times = 3)
symbols(x, y, squares=rep(1, times=9),
        inches=FALSE, # match squares to axes
        xlim=c(0,4),
        ylim=c(4,0)) # flip y axis to match matrix format
board = matrix(rep("E", times=9), nrow=3, ncol=3)

player = "X"
for (i in 1:9) { # loop through 9 turns
  if (player == "X") {
    repeat { # get user input on empty square
      index = identify(x, y, n=1, plot=FALSE)
      row = y[index]
      col = x[index]
      if (board[row, col] == "E") {
        break
      }
    }
  } else { # computer chooses random empty square
    open.indices = which(c(board)=="E")
    index = sample(x=open.indices, size=1)
    row = y[index]
    col = x[index]
  }
  board[row, col] = player
  text(x=x[index], y=y[index], labels=player)
  print(board)
  if (won(board, player)) {
    text(x=2, y=.2, labels=paste(player, "won!"), col="red")
    break
  }
  player = ifelse(player == "X", "O", "X")
}