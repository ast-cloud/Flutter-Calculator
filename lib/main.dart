import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as st;

void main() {
  runApp(MaterialApp(
    theme: new ThemeData.dark(),
    home: Calculator(),
  ));
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String res='0';

  Widget makebttndefault(String l){

    return Expanded(
      child: OutlineButton(onPressed: () {
        setState(() {

            res = res + l;
            if (res.length == 2 && res[0] == '0') {
              res = res.substring(1);
            }

        });
      },
        padding: l=='('||l==')'?EdgeInsets.all(15):EdgeInsets.all(25),
        textColor: Colors.white,
        child: Text(
          l, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),),
        color: Colors.black26,
        splashColor: Colors.white,

      ),
    );
  }

  Widget makebttnclear(String l){

    return Expanded(
      child: OutlineButton(onPressed: () {
        setState(() {

          if (l == 'CE') {
            res = res.substring(0,res.length-1);
          }
          else
            res='0';


        });
      },
        padding: l=='CE'?EdgeInsets.all(15):EdgeInsets.all(25),
        textColor: Colors.white,
        splashColor: Colors.redAccent,
        child: Text(
          l, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),),
        color: Colors.black26,
      ),
    );
  }

  Widget makebttnequal(String l){

    return Expanded(
      child: OutlineButton(onPressed: () {
        setState(() {

          res = calculate(res);

        });
      },
        padding: EdgeInsets.all(25),
        textColor: Colors.white,
        splashColor: Colors.lightGreen,
        child: Text(
          l, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),),
        color: Colors.black26,
      ),
    );
  }



 /* Widget makebttn(String l){
    if(l=='CE' || l=='(' || l==')'){
      return Expanded(
        child: OutlineButton(onPressed: () {
          setState(() {
            if (l == 'CE') {
              res = res.substring(0,res.length-1);
            }
            else {
              res = res + l;
              if (res.length == 2 && res[0] == '0') {
                res = res.substring(1);
              }
            }
          });
        },
          padding: EdgeInsets.all(15),
          textColor: Colors.white,
          child: Text(
            l, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),),
          color: Colors.black26,
        ),
      );
    }
    else {
      return Expanded(
        child: OutlineButton(onPressed: () {
          setState(() {
            if (l == 'C') {
              res = '0';
            }
            else if (l == '=') {
              res = calculate(res);
            }
            else {
              res = res + l;
              if (res.length == 2 && res[0] == '0') {
                res = res.substring(1);
              }
            }
          });
        },
          padding: EdgeInsets.all(25),
          textColor: Colors.white,
          child: Text(
            l, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),),
          color: Colors.black26,
        ),
      );
    }
  }//makebttn*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.bottomRight,
                child: Text(res, style: TextStyle(fontSize: 40),),
              ),
            ),
            Row(
              children: <Widget>[
                makebttndefault('1'),
                makebttndefault('2'),
                makebttndefault('3'),
                makebttnequal('='),
              ],
            ),
            Row(
              children: <Widget>[
                makebttndefault('4'),
                makebttndefault('5'),
                makebttndefault('6'),
                makebttndefault('+'),
              ],
            ),
            Row(
              children: <Widget>[
                makebttndefault('7'),
                makebttndefault('8'),
                makebttndefault('9'),
                makebttndefault('-'),
              ],
            ),
            Row(
              children: <Widget>[
                makebttnclear('C'),
                makebttndefault('0'),
                makebttndefault('/'),
                makebttndefault('*'),
              ],
            ),
            Row(
              children: <Widget>[
                makebttnclear('CE'),
                makebttndefault('('),
                makebttndefault(')'),

              ],
            ),

          ],
        ),
      ),
    );
  }//build

}//_Calculatorstate


String calculate(String expr){


  st.Stack<String> ops = st.Stack();
  st.Stack<int> values = st.Stack();

  for(int i=0;i<expr.length;i++){

    if(expr[i]=='('){
      ops.push('(');
    }
    else if(isDigit(expr, i)){

      int val=0;
      while(i<expr.length && isDigit(expr, i)){
        val=val*10+int.parse(expr[i]);
        i++;
      }
      i--;
      values.push(val);
      print('val = $val');

    }
    else if(expr[i]==')'){

      while(ops.isNotEmpty && ops.top()!='('){

        int val2=values.top();
        values.pop();

        int val1=values.top();
        values.pop();

        String oprtr=ops.top();
        ops.pop();

        values.push(applyOperator(val1, val2, oprtr));

      }
      if(ops.isNotEmpty){
        ops.pop();
      }

    }
    else{

      while(ops.isNotEmpty && precedence(ops.top())>=precedence(expr[i])){
        int val2=values.top();
        values.pop();

        int val1=values.top();
        values.pop();

        String oprtr=ops.top();
        ops.pop();

        values.push(applyOperator(val1, val2, oprtr));
      }
      ops.push(expr[i]);

    }

  }//Entire expr scanned (For closed)

  while(ops.isNotEmpty){
    int val2=values.top();
    values.pop();

    int val1=values.top();
    values.pop();

    String oprtr=ops.top();
    ops.pop();

    values.push(applyOperator(val1, val2, oprtr));
  }

  return values.top().toString();
}

int precedence(String op){
  if(op=='+' || op=='-')
    return 1;
  else if(op=='*' || op=='/')
    return 2;

  return 0;
}

applyOperator(int a, int b, String op){
  switch(op){
    case '+':{
      return a+b;
    }
    break;
    case '-':{
      return a-b;
    }
    break;
    case '*':{
      return a*b;
    }
    break;
    case '/':{
      return a~/b;
    }
  }
}

bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;