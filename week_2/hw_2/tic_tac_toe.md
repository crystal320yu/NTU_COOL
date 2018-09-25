

```python
# Tic tac toe
#https://inventwithpython.com/chapter10.html
import random
```


```python
#劃出方格
#藉由字串創造出井字格
def drawBoard(board):
    print('   |   |')
    print(' ' + board[7] + ' | ' +board[8] + ' | ' + board[9])
    print('   |   |')
    print('------------')
    print('   |   |')
    print(' ' + board[4] + ' | ' +board[5] + ' | ' + board[6])
    print('   |   |')
    print('------------')
    print('   |   |')
    print(' ' + board[1] + ' | ' +board[2] + ' | ' + board[3])
    print('   |   |')
```


```python
#讓玩家選擇要使用的符號'o'或'x'

def inputPlayerLetter():
    letter = ''
    while not (letter =='x' or letter =='o'):
        print('Do you want to be x or o ?')
        letter = input().lower()

#回傳list，玩家的符號在前；電腦的在後

        if letter == 'x':
            return['x','o']
        else:
            return ['o','x']
```


```python
#隨機決定先後順序

def whoGoesFirst():
    if random.randint(0,1) == 0 :
        return 'computer'
    else:
        return 'player'
```


```python
#如果玩家想要再玩一遍，回傳TRUE；否則回傳FALSE。
def playAgain():
    print('Do you want to play again ? (yes or no)')
    return input().lower().startswith('y')
```


```python
def makeMove(board, letter, move):
    board[move] = letter
    

#如果玩家贏，回傳TRUE
#用bo代表board；用le代表letter
#列出各種串成直線的可能
def isWinner(bo, le):
    return((bo[1]==le and bo[2]==le and bo[3]==le) or
          (bo[4]==le and bo[5]==le and bo[6]==le) or
          (bo[7]==le and bo[8]==le and bo[9]==le) or
          (bo[1]==le and bo[5]==le and bo[9]==le) or
          (bo[2]==le and bo[5]==le and bo[8]==le) or
          (bo[3]==le and bo[5]==le and bo[7]==le) or
          (bo[7]==le and bo[4]==le and bo[1]==le) or
          (bo[5]==le and bo[8]==le and bo[2]==le) or
          (bo[3]==le and bo[6]==le and bo[9]==le))

#製造一個重複的board，增加玩家新的移動並回傳
def getBoardCopy(board):
    dupeBoard = []
    for i in board:
        dupeBoard.append(i)
    return dupeBoard

#Return true if the passed move is free on the passed board.
def isSpaceFree(board, move):
    return board[move] == ' '

#讓玩家輸入移動位置
def getPlayerMove(board):
    move = ' '
    while move not in '1 2 3 4 5 6 7 8 9'.split() or not isSpaceFree(board, int(move)):
        print('What is your next move ? (1-9)')
        move = input()
    return int(move)

# Returns a valid move from the passed list on the passed board.
# Returns None if there is no valid move.
def chooseRandomMoveFromList(board, movesList):
    possibleMoves = []
    for i in movesList:
        if isSpaceFree(board, i):
            possibleMoves.append(i)
    
    if len(possibleMoves) != 0:
        return random.choice(possibleMoves)
    else:
        return None   
```


```python
#顯示井字格跟電腦的符號，來決定移動
def getComputerMove(board, computerLwtter):
    if computerLetter == 'x':
        playLetter = 'o'
    else:
        playerLetter = 'x'
        
#接下來為演算法
#首先，先檢查電腦可否在下一步贏得遊戲
    for i in range(1, 10):
        copy = getBoardCopy(board)
        if isSpaceFree(copy, i):
            makeMove(copy, computerLetter, i)
            if isWinner(copy, computerLetter):
                return i
            
#檢查玩家可否在下一步贏得遊戲，並阻擋他
    for i in range(1, 10):
        copy = getBoardCopy(board)
        if isSpaceFree(copy, i):
            makeMove(copy, computerLetter, i)
            if isWinner(copy, computerLetter):
                return i

#如果角落還是空著，試著先佔下角落。
    move = chooseRandomMoveFromList(board, [1, 3, 7, 9])
    if move != None:
        return move
#如果中央還是空著，試著先佔下中央。
    if isSpaceFree(board, 5):
        return 5
#由中央向外移動
    return chooseRandomMoveFromList(board, [2, 4, 6, 8])

#如果井字內格子全滿反傳TRUE，反之，反傳FALSE。
def isBoardFull(board):
    for i in range(1, 10):
        if isSpaceFree(board, i):
            return False
    return True
print('Welcome to Tic Tac Toe !')

while True:
    #重新整理
    theBoard = [' '] * 10
    playerLetter, computerLetter = inputPlayerLetter()
    turn = whoGoesFirst()
    print('The ' + turn + ' will go first.')
    gameIsPlaying = True
    
    while gameIsPlaying:
        if turn == 'player':
            #換玩家玩
            drawBoard(theBoard)
            move = getPlayerMove(theBoard)
            makeMove(theBoard, playerLetter, move)
            
            if isWinner(theBoard, playerLetter):
                drawBoard(theBoard)
                print('Hooray! You have won the game!')
                gameIsPlaying = False
            else:
                if isBoardFull(theBoard):
                    drawBoard(theBoard)
                    print('The game is a tie!')
                    break
                else:
                    turn = 'computer'
        else:
            #換電腦玩
            move = getComputerMove(theBoard, computerLetter)
            makeMove(theBoard, computerLetter, move)
                
            if isWinner(theBoard, computerLetter):
                drawBoard(theBoard)
                print('The computer has beaten you! You lose.')
                gameIsPlaying = False
            else:
                if isBoardFull(theBoard):
                    drawBoard(theBoard)
                    print('The game is a tie!')
                    break
                else:
                    turn = 'player'
                        
    if not playAgain():
        break
                
                
```

    Welcome to Tic Tac Toe !
    Do you want to be x or o ?
    x
    The computer will go first.
       |   |
       |   | o
       |   |
    ------------
       |   |
       |   |  
       |   |
    ------------
       |   |
       |   |  
       |   |
    What is your next move ? (1-9)
    5
       |   |
     o |   | o
       |   |
    ------------
       |   |
       | x |  
       |   |
    ------------
       |   |
       |   |  
       |   |
    What is your next move ? (1-9)
    8
       |   |
     o | x | o
       |   |
    ------------
       |   |
       | x |  
       |   |
    ------------
       |   |
     o |   |  
       |   |
    What is your next move ? (1-9)
    2
       |   |
     o | x | o
       |   |
    ------------
       |   |
       | x |  
       |   |
    ------------
       |   |
     o | x |  
       |   |
    Hooray! You have won the game!
    Do you want to play again ? (yes or no)
    yes
    Do you want to be x or o ?
    o
    The computer will go first.
       |   |
     x |   |  
       |   |
    ------------
       |   |
       |   |  
       |   |
    ------------
       |   |
       |   |  
       |   |
    What is your next move ? (1-9)
    5
       |   |
     x |   |  
       |   |
    ------------
       |   |
       | o |  
       |   |
    ------------
       |   |
       |   | x
       |   |
    What is your next move ? (1-9)
    8
       |   |
     x | o | x
       |   |
    ------------
       |   |
       | o |  
       |   |
    ------------
       |   |
       |   | x
       |   |
    What is your next move ? (1-9)
    2
       |   |
     x | o | x
       |   |
    ------------
       |   |
       | o |  
       |   |
    ------------
       |   |
       | o | x
       |   |
    Hooray! You have won the game!
    Do you want to play again ? (yes or no)
    no
    
