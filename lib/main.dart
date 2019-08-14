import 'package:flutter/material.dart';
import './fillEntry.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> origBoard = new List(9);
  List<Color> colorCell = new List(9);
  static var huPlayer = '0';
  static var aiPlayer = 'X';
  static var _color = Color(0xfafafa);
  bool _switchPlayer = true;

  static var winCombos = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2]
  ];

  var winnerCombo;

  void startGame(){
    setState(() {
      origBoard = new List(9);
      colorCell = new List(9);
      _color = Color(0xfffafafa);
      winnerCombo = null;
    });
  }

  @override
  void initState() {
    super.initState();
    this.startGame();
  }

  void _userClicker(cellId){
    print("clicked : " + cellId.toString());
    _occupyCell(cellId,huPlayer);
  }

  bool checkGamePlay(field){
      for(var i= 0 ; i< winCombos.length; i++){
        if( (origBoard[winCombos[i][0]] != null && origBoard[winCombos[i][0]]== field) && 
            (origBoard[winCombos[i][1]] != null && origBoard[winCombos[i][1]]== field) && 
            (origBoard[winCombos[i][2]] != null && origBoard[winCombos[i][2]]== field)  ){
            setState(() {
              winnerCombo = winCombos[i];
            });
            return true;
        }
      }
      //Check For all fields are Filled or Not
      for(var i = 0; i< origBoard.length; i++){
        if(origBoard[i] == null){
          return false;
        }
      }
      return true;
  }

  void _occupyCell(cellId,field){
    setState(() {
      if(origBoard[cellId] == null){
        origBoard[cellId] = field;
      }else if(origBoard[cellId]== field)
        print('already present');
      else if(origBoard[cellId] != field)
        print('Taken By other Player');
    });
    //Check Game Over or Not
    if(checkGamePlay(field)){
      //TODO Announce for winner
      if(winnerCombo!= null){
        for(int i=0; i<3;i++){
          setState(() {
           colorCell[winnerCombo[i]] = Colors.green; 
          });
        }
        print("game over, " + field + ' won');
      }else{
        print('Game Tie');
      }
    }else{
      print("next Play");
      if(field==huPlayer){
        //TODO Ai Should Play Next
        print('AI Turn');
        _occupyCell(bestSpot(),aiPlayer);
      }else{
        print('User Turn');
      }
    }
  }

  emptySpots(board){
    List<int> emptySpots = new List();
    for(var i =0; i<board.length; i++){
      if(board[i]== null){
        emptySpots.add(i);
      }
    }
    return emptySpots;
  }

  bestSpot(){
    /*
      Minmax Alogrithm:
        1) return a value if a terminal state is found (+10,0,-10)
        2) go through available spots on board
        3) call the minmax funcation on each available spot (recursion)
        4) wvaluate retuning value from funaction calls
        5) and return the best value
    */
    
    print('best spot : ' + minmax(new List.from(     origBoard),aiPlayer).toString());
    return minmax(new List.from(   origBoard),aiPlayer)['index'];
  }

  minmax(newBoard,player){
    List<int> availSpots = emptySpots(newBoard);

    if (checkGamePlay(huPlayer)) {
      return {'score': -10};
    } else if (checkGamePlay(aiPlayer)) {
      return {'score': 10};
    } else if (availSpots.length == 0) {
      return {'score': 0};
    }

    var moves=[];
    for(var i =0; i< availSpots.length; i++){
      var move = new Map();
      move['index'] = availSpots[i];
      newBoard[availSpots[i]] = player;

      if(player == aiPlayer){
        var result  = minmax(newBoard, huPlayer);
        move['score'] = result['score'];
      }else{
        var result  = minmax(newBoard, aiPlayer);
        move['score'] = result['score'];
      }

      newBoard[availSpots[i]] = move['index'];

      moves.add(move);
    }

    var bestMove;

    if(player == aiPlayer) {
      var bestScore = -10000;
      for(var i = 0; i < moves.length; i++) {
        if (moves[i]['score'] > bestScore) {
          bestScore = moves[i]['score'];
          bestMove = i;
        }
      }
    } else {
      var bestScore = 10000;
      for(var i = 0; i < moves.length; i++) {
        if (moves[i]['score'] < bestScore) {
          bestScore = moves[i]['score'];
          bestMove = i;
        }
      }
    }

    return moves[bestMove];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Text("Welcome to the Game")
                ),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              _userClicker(0);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  bottom: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                ),
                              ),
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              child: FillEntry(colorCell[0]==null?_color:colorCell[0],origBoard[0],(colorCell[0]==null?true:false)),
                            ),
                          ), //Top Left,
                          GestureDetector(
                            onTap: (){
                              _userClicker(1);
                            },
                            child:Container(
                            decoration: const BoxDecoration(
                              color: Color(0xfafafa),
                              border: Border(
                                left: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                right: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                bottom: BorderSide(width: 2, color: Color(0xFFFF000000)),
                              ),
                            ),
                            width: 75,
                            height: 75,
                            alignment: Alignment.center,
                            child: FillEntry(colorCell[1]==null?_color:colorCell[1],origBoard[1],(colorCell[1]==null?true:false)),
                            ), //Top Center
                          ),
                          GestureDetector(
                            onTap: (){
                              _userClicker(2);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xfafafa),
                                border: Border(
                                  left: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  bottom: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                ),
                              ),
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              child: FillEntry(colorCell[2]==null?_color:colorCell[2],origBoard[2],(colorCell[2]==null?true:false)),
                           ) //Top Right
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              _userClicker(3);
                            },
                            child:Container(
                            decoration: const BoxDecoration(
                              color: Color(0xfafafa),
                              border: Border(
                                top: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                right: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                bottom: BorderSide(width: 2, color: Color(0xFFFF000000)),
                              ),
                            ),
                            width: 75,
                            height: 75,
                            alignment: Alignment.center,
                            child: FillEntry(colorCell[3]==null?_color:colorCell[3],origBoard[3],(colorCell[3]==null?true:false)),
                          ), //Middle Left
                          
                          ),
                          GestureDetector(
                            onTap: (){
                              _userClicker(4);
                            },
                            child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xfafafa),
                              border: Border(
                                top: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                left: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                right: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                bottom: BorderSide(width: 2, color: Color(0xFFFF000000)),
                              ),
                            ),
                            width: 75,
                            height: 75, 
                            alignment: Alignment.center,
                            child: FillEntry(colorCell[4]==null?_color:colorCell[4],origBoard[4],(colorCell[4]==null?true:false)),
                          ), //Middle Center
                          
                          ),
                          GestureDetector(
                            onTap: (){
                              _userClicker(5);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xfafafa),
                                border: Border(
                                  top: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  left: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  bottom: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                ),
                              ),
                              width: 75,
                              height: 75, 
                              alignment: Alignment.center,
                              child: FillEntry(colorCell[5]==null?_color:colorCell[5],origBoard[5],(colorCell[5]==null?true:false)),
                            ) //Middle Right
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              _userClicker(6);
                            },
                            child:Container(
                              decoration: const BoxDecoration(
                                color: Color(0xfafafa),
                                border: Border(
                                  top: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  right: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                ),
                              ),
                              width: 75,
                              height: 75, 
                              alignment: Alignment.center,
                              child: FillEntry(colorCell[6]==null?_color:colorCell[6],origBoard[6],(colorCell[6]==null?true:false)),
                            ), //Bottom Left
                          ),
                          GestureDetector(
                            onTap: (){
                              _userClicker(7);
                            },
                            child:  Container(
                              decoration: const BoxDecoration(
                                color: Color(0xfafafa),
                                border: Border(
                                  top: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  left: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  right: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                ),
                              ),
                              width: 75,
                              height: 75, 
                              alignment: Alignment.center,
                              child: FillEntry(colorCell[7]==null?_color:colorCell[7],origBoard[7],(colorCell[7]==null?true:false)),
                            ), //Bottom Center
                          ),
                          GestureDetector(
                            onTap: (){
                              _userClicker(8);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xfafafa),
                                border: Border(
                                  top: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  left: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                ),
                              ),
                              width: 75,
                              height: 75, 
                              alignment: Alignment.center,
                              child: FillEntry(colorCell[8]==null?_color:colorCell[8],origBoard[8],(colorCell[8]==null?true:false)),
                            ) //Bottom Right
                          ),
                        ]
                      )
                    ],
                  ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: Text("You are a winner")
                ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startGame,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), 
    );
  }
}
