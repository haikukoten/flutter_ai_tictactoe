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
  static var huPlayer = '0';
  static var aiPlayer = 'X';

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

  static var winnerCombo;

  void startGame(){
    setState(() {
      origBoard = new List(9);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.startGame();
  }

  void _userClicker(cellId){
    print("clicked : " + cellId.toString());
    _occupyCell(cellId,huPlayer);
  }

  bool checkGamePlay(field){
      bool gameWon = false;
      for(var i= 0 ; i< winCombos.length; i++){
        if( (origBoard[winCombos[i][0]] != null && origBoard[winCombos[i][0]]== field) && 
            (origBoard[winCombos[i][1]] != null && origBoard[winCombos[i][1]]== field) && 
            (origBoard[winCombos[i][2]] != null && origBoard[winCombos[i][2]]== field)  ){
            gameWon = true;
            setState(() {
              winnerCombo = winCombos[i];
            });
            break;
        }
      }
      //Check For all fields are Filled or Not
      if(!gameWon){
        for(var i = 0; i< origBoard.length; i++){
          if(origBoard[i] == null){
            gameWon = false;
            break;
          }
        }
      }
      return gameWon;
  }

  void _occupyCell(cellId,field){
    setState(() {
      if(origBoard[cellId] == null)
        origBoard[cellId] = field;
      else if(origBoard[cellId]== field)
        print('already present');
      else if(origBoard[cellId] != field)
        print('Taken By other Player');
    });
    //Check Game Over or Not
    if(checkGamePlay(field) == true){
      print("game over, " + field + ' won');
      //TODO Announce for winner

    }else{
      print("next Play");
      if(field!=huPlayer){
        //TODO Ai Should Play Next
      }else{
        print('User Turn');
      }
    }
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
                                color: Color(0xfafafa),
                                border: Border(
                                  right: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                  bottom: BorderSide(width: 2, color: Color(0xFFFF000000)),
                                ),
                              ),
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              child: FillEntry(origBoard[0]),
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
                            child: FillEntry(origBoard[1]),
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
                              child: FillEntry(origBoard[2]),
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
                            child: FillEntry(origBoard[3]),
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
                            child: FillEntry(origBoard[4]),
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
                              child: FillEntry(origBoard[5]),
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
                              child: FillEntry(origBoard[6]),
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
                              child: FillEntry(origBoard[7]),
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
                              child: FillEntry(origBoard[8]),
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
