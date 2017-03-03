//ClientApp.pde

//オセロの対戦ゲーム
//ServerAppが白(先攻)、ClientAppが黒です

//2016/11/28

import processing.net.*;
Client myClient=new Client(this, "127.0.0.1", 12345);

PFont myFont;
int []status=new int[64];
//ターン(Clientは黒(奇数))
int turn=0;
//置けるかどうか
boolean can;

void setup() {
  size(400, 600);
  cursor(HAND);
  background(28, 173, 21);
  myFont = createFont("MSゴシック", 10);
  textFont(myFont);
  //初期値は0で、描かない状態
  for (int i=0; i<64; i++) {
    status[i] = 0;
  }
  //初期位置
  status[27] = 1;
  status[28] = 2;
  status[35] = 2;
  status[36] = 1;
}

void draw() {
  background(28, 173, 21);

  //使用可能か確認
  if (myClient.available()>0) {
    String strBuffer=myClient.readString();
    String data[]=split(strBuffer, ",");
    for (int i=0; i<65; i++) {
      turn=int(data[0]);
      if (i!=0) {
        status[i-1]=int(data[i]);
      }
    }
  }
  //マス目7
  for (int j=0; j<8; j++) {
    for (int i=0; i<8; i++) {
      stroke(0);
      noFill();
      rect(i*50, j*50, 50, 50);
    }
  }


  //置けるならコマを置く
  for (int j=0; j<8; j++) {
    for (int i=0; i<8; i++) {
      //白か黒か
      if (status[i+j*8] == 1) {
        //白を置く
        fill(-1);
        stroke(0);
        ellipse(25+i*50, 25+j*50, 40, 40);
      } else if (status[i+j*8] == 2) {
        //黒を置く
        fill(0);
        stroke(0);
        ellipse(25+i*50, 25+j*50, 40, 40);
      }
    }
  }
  can = false;

  //whiteとblackのカウント
  int wcnt=0;
  int bcnt=0;
  for (int i=0; i<status.length; i++) {
    if (status[i]==1) {
      wcnt++;
    } else if (status[i]==2) {
      bcnt++;
    }
  }
  stroke(0);
  fill(-1);
  rect(0, 400, 400, 200);
  fill(0);
  textSize(50);
  text("自分:●× "+bcnt, 80, 450);
  text("相手:〇× "+wcnt, 80, 510);
  textSize(20);
  text("パス：置けない場所をクリック", 20, 580);

  //ターン表示
  fill(255, 0, 0);
  if (turn%2==0) {
    ellipse(40, 490, 30, 30);
  } else if (turn%2==1) {
    ellipse(40, 430, 30, 30);
  }
}

void stop() {
  myClient.stop();
}

void mousePressed() {
  //黒はtrueターン
  if (turn%2==1) {
    //どのコマを押したか
    int tx = mouseX/50;
    int ty = mouseY/50;
    if (mouseY<400) {
      if (mouseX>=tx*50 && mouseX<=(tx+1)*50 && mouseY>=ty*50 && mouseY<=(ty+1)*50) {

        //何もないマスにターンに応じて決まった色のコマを置く
        if (!can && status[tx+ty*8]==0) {
          //置いた後の反転
          //縦の反転判定
          if (tx+1<7 && status[tx+1+ty*8]==1) {
            if (status[tx+2+ty*8]==2) { //2個上と挟む
              status[tx+1+ty*8] = 2;
              can = true;
            } else if (tx+2<7 && status[tx+2+ty*8]==1) {
              if (status[tx+3+ty*8]==2) { //3個上と挟む
                status[tx+1+ty*8] = 2;
                status[tx+2+ty*8] = 2;
                can = true;
              } else if (tx+3<7 && status[tx+3+ty*8]==1) {
                if (status[tx+4+ty*8]==2) { //4個上と挟む
                  for (int i=1; i<4; i++) {
                    status[tx+i+ty*8] = 2;
                    can = true;
                  }
                } else if (tx+4<7 && status[tx+4+ty*8]==1) {
                  if (status[tx+5+ty*8]==2) { //5個上と挟む
                    for (int i=1; i<5; i++) {
                      status[tx+i+ty*8] = 2;
                      can = true;
                    }
                  } else if (tx+5<7 && status[tx+5+ty*8]==1) {
                    if (status[tx+6+ty*8]==2) { //6個上と挟む
                      for (int i=1; i<6; i++) {
                        status[tx+i+ty*8] = 2;
                        can = true;
                      }
                    } else if (tx+6<7 && status[tx+6+ty*8]==1 && status[tx+7+ty*8]==2) {
                      for (int i=1; i<7; i++) { //7個上と挟む
                        status[tx+i+ty*8] = 2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }
          //黒：右の駒と挟む
          if (tx-1>0 && status[tx-1+ty*8]==1) {
            if (status[tx-2+ty*8]==2) { //2個上と挟む
              status[tx-1+ty*8] = 2;
              can = true;
            } else if (tx-2>0 && status[tx-2+ty*8]==1) {
              if (status[tx-3+ty*8]==2) { //3個上と挟む
                status[tx-1+ty*8] = 2;
                status[tx-2+ty*8] = 2;
                can = true;
              } else if (tx-3>0 && status[tx-3+ty*8]==1) {
                if (status[tx-4+ty*8]==2) { //4個上と挟む
                  for (int i=1; i<4; i++) {
                    status[tx-i+ty*8] = 2;
                    can = true;
                  }
                } else if (tx-4>0 && status[tx-4+ty*8]==1) {
                  if (status[tx-5+ty*8]==2) { //5個上と挟む
                    for (int i=1; i<5; i++) {
                      status[tx-i+ty*8] = 2;
                      can = true;
                    }
                  } else if (tx-5>0 && status[tx-5+ty*8]==1) {
                    if (status[tx-6+ty*8]==2) { //6個上と挟む
                      for (int i=1; i<6; i++) {
                        status[tx-i+ty*8] = 2;
                        can = true;
                      }
                    } else if (tx-6>0 && status[tx-6+ty*8]==1 && status[tx-7+ty*8]==2) {
                      for (int i=1; i<7; i++) { //7個上と挟む
                        status[tx-i+ty*8] = 2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }
          //黒：下の駒と挟む
          if (ty+1<7 && status[tx+(ty+1)*8]==1) {
            if (status[tx+(ty+2)*8]==2) { //2個上と挟む
              status[tx+(ty+1)*8] = 2;
              can = true;
            } else if (ty+2<7 && status[tx+(ty+2)*8]==1) {
              if (status[tx+(ty+3)*8]==2) { //3個上と挟む
                status[tx+(ty+1)*8] = 2;
                status[tx+(ty+2)*8] = 2;
                can = true;
              } else if (ty+3<7 && status[tx+(ty+3)*8]==1) {
                if (status[tx+(ty+4)*8]==2) { //4個上と挟む
                  for (int i=1; i<4; i++) {
                    status[tx+(ty+i)*8] = 2;
                    can = true;
                  }
                } else if (ty+4<7 && status[tx+(ty+4)*8]==1) {
                  if (status[tx+(ty+5)*8]==2) { //5個上と挟む
                    for (int i=1; i<5; i++) {
                      status[tx+(ty+i)*8] = 2;
                      can = true;
                    }
                  } else if (ty+5<7 && status[tx+(ty+5)*8]==1) {
                    if (status[tx+(ty+6)*8]==2) { //6個上と挟む
                      for (int i=1; i<6; i++) {
                        status[tx+(ty+i)*8] = 2;
                        can = true;
                      }
                    } else if (ty+6<7 && status[tx+(ty+6)*8]==1 && status[tx+(ty+7)*8]==2) {
                      for (int i=1; i<7; i++) { //7個上と挟む
                        status[tx+(ty+i)*8] = 2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }
          //黒：上の駒と挟む
          if (ty-1>0 && status[tx+(ty-1)*8]==1) {
            if (status[tx+(ty-2)*8]==2) { //2個上と挟む
              status[tx+(ty-1)*8] = 2;
              can = true;
            } else if (ty-2>0 && status[tx+(ty-2)*8]==1) {
              if (status[tx+(ty-3)*8]==2) { //3個上と挟む
                status[tx+(ty-1)*8] = 2;
                status[tx+(ty-2)*8] = 2;
                can = true;
              } else if (ty-3>0 && status[tx+(ty-3)*8]==1) {
                if (status[tx+(ty-4)*8]==2) { //4個上と挟む
                  for (int i=1; i<4; i++) {
                    status[tx+(ty-i)*8] = 2;
                    can = true;
                  }
                } else if (ty-4>0 && status[tx+(ty-4)*8]==1) {
                  if (status[tx+(ty-5)*8]==2) { //5個上と挟む
                    for (int i=1; i<5; i++) {
                      status[tx+(ty-i)*8] = 2;
                      can = true;
                    }
                  } else if (ty-5>0 && status[tx+(ty-5)*8]==1) {
                    if (status[tx+(ty-6)*8]==2) { //6個上と挟む
                      for (int i=1; i<6; i++) {
                        status[tx+(ty-i)*8] = 2;
                        can = true;
                      }
                    } else if (ty-6>0 && status[tx+(ty-6)*8]==1 && status[tx+(ty-7)*8]==2) {
                      for (int i=1; i<7; i++) { //7個上と挟む
                        status[tx+(ty-i)*8] = 2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }
          //黒：右下の駒と挟む
          if (tx+1<7 && ty+1<7 && status[tx+1+(ty+1)*8]==1) {
            if (status[tx+2+(ty+2)*8]==2) { //2個右下と挟む
              status[tx+1+(ty+1)*8] = 2;
              can = true;
            } else if (tx+2<7 && ty+2<7 && status[tx+2+(ty+2)*8]==1) {
              if (status[tx+3+(ty+3)*8]==2) { //3個右下と挟む
                status[tx+1+(ty+1)*8] = 2;
                status[tx+2+(ty+2)*8] = 2;
                can = true;
              } else if (tx+3<7 && ty+3<7 && status[tx+3+(ty+3)*8]==1) {
                if (status[tx+4+(ty+4)*8]==2) { //4個右下と挟む
                  for (int i=1; i<4; i++) {
                    status[tx+i+(ty+i)*8] = 2;
                    can = true;
                  }
                } else if (tx+4<7 && ty+4<7 && status[tx+4+(ty+4)*8]==1) {
                  if (status[tx+5+(ty+5)*8]==2) { //5個右下と挟む
                    for (int i=1; i<5; i++) {
                      status[tx+i+(ty+i)*8] = 2;
                      can = true;
                    }
                  } else if (tx+5<7 && ty+5<7 && status[tx+5+(ty+5)*8]==1) {
                    if (status[tx+6+(ty+6)*8]==2) { //6個右下と挟む
                      for (int i=1; i<6; i++) {
                        status[tx+i+(ty+i)*8] = 2;
                        can = true;
                      }
                    } else if (tx+6<7 && ty+6<7 && status[tx+6+(ty+6)*8]==1 && status[tx+7+(ty+7)*8]==2) {
                      for (int i=1; i<7; i++) { //7個右下と挟む
                        status[tx+i+(ty+i)*8] = 2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }
          //黒：左上の駒と挟む
          if (tx-1>0 && ty-1>0 && status[tx-1+(ty-1)*8]==1) {
            if (status[tx-2+(ty-2)*8]==2) { //2個左上と挟む
              status[tx-1+(ty-1)*8] = 2;
              can = true;
            } else if (tx-2>0 && ty-2>0 && status[tx-2+(ty-2)*8]==1) {
              if (status[tx-3+(ty-3)*8]==2) { //3個左上と挟む
                status[tx-1+(ty-1)*8] = 2;
                status[tx-2+(ty-2)*8] = 2;
                can = true;
              } else if (tx-3>0 && ty-3>0 && status[tx-3+(ty-3)*8]==1) {
                if (status[tx-4+(ty-4)*8]==2) { //4個左上と挟む
                  for (int i=1; i<4; i++) {
                    status[tx-i+(ty-i)*8] = 2;
                    can = true;
                  }
                } else if (tx-4>0 && ty-4>0 && status[tx-4+(ty-4)*8]==1) {
                  if (status[tx-5+(ty-5)*8]==2) { //5個左上と挟む
                    for (int i=1; i<5; i++) {
                      status[tx-i+(ty-i)*8] = 2;
                      can = true;
                    }
                  } else if (tx-5>0 && ty-5>0 && status[tx-5+(ty-5)*8]==1) {
                    if (status[tx-6+(ty-6)*8]==2) { //6個左上と挟む
                      for (int i=1; i<6; i++) {
                        status[tx-i+(ty-i)*8] = 2;
                        can = true;
                      }
                    } else if (tx-6>0 && ty-6>0 && status[tx-6+(ty-6)*8]==1 && status[tx-7+(ty-7)*8]==2) {
                      for (int i=1; i<7; i++) { //7個左上と挟む
                        status[tx-i+(ty-i)*8] = 2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }
          //黒：左下の駒と挟む
          if (tx-1>0 && ty+1<7 && status[tx-1+(ty+1)*8]==1) {
            if (status[tx-2+(ty+2)*8]==2) { //2個左下と挟む
              status[tx-1+(ty+1)*8] = 2;
              can = true;
            } else if (tx-2>0 && ty+2<7 && status[tx-2+(ty+2)*8]==1) {
              if (status[tx-3+(ty+3)*8]==2) { //3個左下と挟む
                status[tx-1+(ty+1)*8] = 2;
                status[tx-2+(ty+2)*8] = 2;
                can = true;
              } else if (tx-3>0 && ty+3<7 && status[tx-3+(ty+3)*8]==1) {
                if (status[tx-4+(ty+4)*8]==2) { //4個左下と挟む
                  for (int i=1; i<4; i++) {
                    status[tx-i+(ty+i)*8] = 2;
                    can = true;
                  }
                } else if (tx-4>0 && ty+4<7 && status[tx-4+(ty+4)*8]==1) {
                  if (status[tx-5+(ty+5)*8]==2) { //5個左下と挟む
                    for (int i=1; i<5; i++) {
                      status[tx-i+(ty+i)*8] = 2;
                      can = true;
                    }
                  } else if (tx-5>0 && ty+5<7 && status[tx-5+(ty+5)*8]==1) {
                    if (status[tx-6+(ty+6)*8]==2) { //6個左下と挟む
                      for (int i=1; i<6; i++) {
                        status[tx-i+(ty+i)*8] = 2;
                        can = true;
                      }
                    } else if (tx-6>0 && ty+6<7 && status[tx-6+(ty+6)*8]==1 && status[tx-7+(ty+7)*8]==2) {
                      for (int i=1; i<7; i++) { //7個左下と挟む
                        status[tx-i+(ty+i)*8] = 2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }
          //黒：右上の駒と挟む
          if (tx+1<7 && ty-1>0 && status[tx+1+(ty-1)*8]==1) {
            if (status[tx+2+(ty-2)*8]==2) { //2個右上と挟む
              status[tx+1+(ty-1)*8] = 2;
              can = true;
            } else if (tx+2<7 && ty-2>0 && status[tx+2+(ty-2)*8]==1) {
              if (status[tx+3+(ty-3)*8]==2) { //3個右上と挟む
                status[tx+1+(ty-1)*8] = 2;
                status[tx+2+(ty-2)*8] = 2;
                can = true;
              } else if (tx+3<7 && ty-3>0 && status[tx+3+(ty-3)*8]==1) {
                if (status[tx+4+(ty-4)*8]==2) { //4個右上と挟む
                  for (int i=1; i<4; i++) {
                    status[tx+i+(ty-i)*8] = 2;
                    can = true;
                  }
                } else if (tx+4<7 && ty-4>0 && status[tx+4+(ty-4)*8]==1) {
                  if (status[tx+5+(ty-5)*8]==2) { //5個右上と挟む
                    for (int i=1; i<5; i++) {
                      status[tx+i+(ty-i)*8] = 2;
                      can = true;
                    }
                  } else if (tx+5<7 && ty-5>0 && status[tx+5+(ty-5)*8]==1) {
                    if (status[tx+6+(ty-6)*8]==2) { //6個右上と挟む
                      for (int i=1; i<6; i++) {
                        status[tx+i+(ty-i)*8] = 2;
                        can = true;
                      }
                    } else if (tx+6<7 && ty-6>0 && status[tx+6+(ty-6)*8]==1 && status[tx+7+(ty-7)*8]==2) {
                      for (int i=1; i<7; i++) { //7個右上と挟む
                        status[tx+i+(ty-i)*8] =2;
                        can = true;
                      }
                    }
                  }
                }
              }
            }
          }//黒：右上
          if (can) {
            status[tx+ty*8] = 2;
          }
          //パス
          turn++;
        }//反転について
      }//コマ配置
    }//押した判定
  }

  //全てのマスの情報を入力してサーバーに送信
  String []lines = new String[8];
  for (int i=0; i<lines.length; i++) {
    lines[i]=str(status[i*8])+","+str(status[i*8+1])+","+str(status[i*8+2])+","
      +str(status[i*8+3])+","+str(status[i*8+4])+","+str(status[i*8+5])+","
      +str(status[i*8+6])+","+str(status[i*8+7]);
  }
  myClient.write(str(turn)+","+lines[0]+","+lines[1]+","+lines[2]+","+lines[3]+","
    +lines[4]+","+lines[5]+","+lines[6]+","+lines[7]);
}
