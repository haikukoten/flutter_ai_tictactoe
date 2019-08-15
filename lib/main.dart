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
  static var huPlayer = 'O';
  static var aiPlayer = 'X';
  static var _color = Color(0xfafafa);  
  var winnerCombo;

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
    if(winnerCombo == null){
      _occupyCell(cellId,huPlayer);
    }else{
      print("Game is already won");
    }
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

  bool analysGamePlay(board,field){
    //Check for winnning combo
      for(var i= 0 ; i< winCombos.length; i++){
        if( (board[winCombos[i][0]].toString() != null && board[winCombos[i][0]].toString()== field) && 
            (board[winCombos[i][1]].toString() != null && board[winCombos[i][1]].toString()== field) && 
            (board[winCombos[i][2]].toString() != null && board[winCombos[i][2]].toString()== field) ){
            return true;
        }
      }
      //check all space occupied
      for(var i = 0; i< board.length; i++){
        if(board[i].toString() != aiPlayer && board[i].toString() != huPlayer){
          return false;
        }
      }
      return false;
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
      if(winnerCombo!= null){
        for(int i=0; i<3;i++){
          setState(() {
           colorCell[winnerCombo[i]] = (field==huPlayer? Colors.green : Colors.red); 
          });
        }
        _showDialog("You Lost");
        print("game over, " + field + ' won');
      }else{
        _showDialog("Game Tie");
        //print('Game Tie');
      }
    }else{
      print("next Play");
      if(field==huPlayer){
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
      if(board[i].toString() != aiPlayer && board[i].toString() != huPlayer){
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
    List tempBoard = new List.from(origBoard);
    for(int i = 0; i<tempBoard.length ; i++){
      if(tempBoard[i]== null){
        tempBoard[i] = i;
      }
    }
    return minmax(tempBoard,aiPlayer)['index'];
  }

  minmax(newBoard,player){
    List<int> availSpots = emptySpots(newBoard);
    if (analysGamePlay(newBoard,huPlayer)) {
      return {'score': -10};
    } else if (analysGamePlay(newBoard,aiPlayer)) {
      return {'score': 10};
    } else if (availSpots.length == 0) {
      return {'score': 0};
    }

    var moves=[];
    for(var i =0; i< availSpots.length; i++){
      var move = new Map();
      move['index'] = newBoard[availSpots[i]];
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

  void _showDialog(message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(message, style: TextStyle(fontWeight: FontWeight.bold),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Restart"),
              onPressed: () {
                startGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Text("Welcome to the Challenge",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold))
                ),
              Container(
                  padding: EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                  height: 500,
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
                              width: 100,
                              height: 100,
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
                            width: 100,
                            height: 100,
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
                              width: 100,
                              height: 100,
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
                            width: 100,
                            height: 100,
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
                            width: 100,
                            height: 100, 
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
                              width: 100,
                              height: 100, 
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
                              width: 100,
                              height: 100, 
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
                              width: 100,
                              height: 100, 
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
                              width: 100,
                              height: 100, 
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
                child: Text("Beat my AI,",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
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
