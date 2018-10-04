# 猜數字遊戲
# 基本
# 1. 請寫一個由"電腦隨機產生"1~99的數字
# 2. 玩家可"重覆"猜電腦所產生的數字，並提示"Bigger" or "smaller"
# 3. 玩家如果猜對遊戲結束

guess.number <- function()
{ 
  n <- readline(prompt="Enter a number(1-99).: ")
  if(!grepl("^[0-9]+$",n))
  {
    return(guess.number())
  }
  return(as.integer(n))
}


num <- sample(1:99)
guess <- -2

cat("Enter a number(1-99): ")

while(guess != num){ 
  guess <- guess.number()
  if (guess == num)
  {
    cat("Correct!!!\n")
  }
  else if (guess < num)
  {
    cat("Try a bigger one !\n")
  }
  else if(guess > num)
  {
    cat("Try a smaller one !\n")
  }
}
