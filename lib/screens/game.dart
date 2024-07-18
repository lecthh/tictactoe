import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/game_logic.dart';
import 'package:final_proj/screens/home.dart';
import 'package:final_proj/services/auth_service.dart';
import 'package:final_proj/services/chat_service.dart';
import 'package:final_proj/utils/app_colors.dart';
import 'package:final_proj/utils/chat_bubble.dart';
import 'package:final_proj/utils/primary_button.dart';
import 'package:final_proj/utils/textbox.dart';
import 'package:final_proj/utils/ttt_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Game extends StatefulWidget {
  final String roomId;

  const Game({super.key, required this.roomId});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final authService = AuthService();
  final chatService = ChatService();

  late String username = '';
  TextEditingController messageController = TextEditingController();
  late DocumentReference gameId;
  late Stream<DocumentSnapshot> gameStream;
  late Map<String, dynamic> gameData = {};
  bool playerLeft = false;

  @override
  void initState() {
    super.initState();
    gameId = FirebaseFirestore.instance.collection('gameRooms').doc(widget.roomId);
    gameStream = gameId.snapshots();
    initUsername();
  }

  void initUsername() async {
    String? fetchedUsername = await authService.getUsername();
    if (fetchedUsername != null) {
      setState(() {
        username = fetchedUsername;
      });
    } else {
      if (kDebugMode) {
        print('username not available');
      }
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.roomId, messageController.text);
      messageController.clear();
    }
  }

  void makeMove(int index) async {
    if (gameData['player2'] == null) {
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Waiting for opponents to join...",
            style: GoogleFonts.shareTech(fontSize: 16, color: kPink),
          ),
        ));
      }
      return;
    }

    if (gameData['board'][index] != 0 ||
        gameData['turn'] != (username == gameData['player1'] ? 1 : 2)) {
      return;
    }

    List<dynamic> newBoard = List.from(gameData['board']);
    newBoard[index] = gameData['turn'];

    int nextTurn = gameData['turn'] == 1 ? 2 : 1;
    await gameId.update({'board': newBoard, 'turn': nextTurn});

    int winner = GameLogic.checkWinner(newBoard);
    if (winner != 0) {
      await gameId.update({
        'winner': winner,
      });
    } else if (!GameLogic.hasEmptyCell(newBoard)) {
      await gameId.update({
        'winner': -1, // Draw
      });
    }
  }

  void leaveGame() {
    FirebaseFirestore.instance
      .collection('gameRooms')
      .doc(widget.roomId)
      .update({
        'playerLeft': authService.getEmail(),
      })
      .then((_) {
        setState(() {
          playerLeft = true;
        });
      })
      .catchError((error) {
        if (kDebugMode) {
          print("Error leaving game: $error");
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBlack,
      child: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: gameStream,
          builder: (context, snapshot) {
            
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.data() == null) {
              return const Center(child: CircularProgressIndicator());
            }

            gameData = (snapshot.data!.data()! as Map<String, dynamic>?) ?? {};

            
            if (playerLeft) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Home())
                );
              });
              return const SizedBox.shrink();
            }

            List<dynamic> board = gameData['board'];
            String player1 = gameData['player1'];
            String player2 = gameData['player2'] ?? 'waiting...';
            // ignore: unused_local_variable
            int turn = gameData['turn'];
            int winner = gameData['winner'] ?? 0;

            return Padding(
              padding: const EdgeInsets.fromLTRB(32, 25, 32, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('gameRooms')
                            .doc(widget.roomId)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>?;
                            return Text(
                              "Room ID: ${data?['roomId'] ?? widget.roomId}",
                              style: GoogleFonts.shareTech(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.pink,
                                ),
                              ),
                            );
                          } else {
                            return const Text("Loading...");
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: leaveGame,
                        child: Text(
                          'leave game',
                          style:
                              GoogleFonts.shareTech(fontSize: 16, color: kPink),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "X: $player1  |  O: $player2",
                    style: GoogleFonts.shareTech(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: kYellow,
                      ),
                    ),
                  ),
                  // board
                  Column(
                    children: [
                      if (winner != 0)
                        Text(
                          winner == -1
                              ? 'It\'s a draw!'
                              : 'Player ${winner == 1 ? player1 : player2} wins!',
                          style:
                              GoogleFonts.shareTech(fontSize: 24, color: kPink),
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      for (int i = 0; i < 3; i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < 3; j++) ...[
                              TttBox(
                                value: board[i * 3 + j] == 0
                                    ? ""
                                    : board[i * 3 + j].toString(),
                                onTap: () => makeMove(i * 3 + j),
                              ),
                              if (j < 2) const SizedBox(width: 12),
                            ]
                          ],
                        ),
                        if (i < 2) const SizedBox(height: 12),
                      ]
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 280,
                        child: Expanded(
                          child: _buildMessageList(),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 260,
                            child: Textbox(
                              text: "Type a message...",
                              color: kYellow,
                              isObscure: false,
                              controller: messageController,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: sendMessage,
                            child: const PrimaryButton(
                              text: "send",
                              color: kGreen,
                              isStatic: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(
          widget.roomId, gameData['player1'], gameData['player2'] ?? ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    String currentUser = authService.getCurrentUser().toString();

    bool isMe = data['sender'] == currentUser;

    bool isPlayer2 = data['sender'] == gameData['player2'];

    String senderUsername = data['sender'];

    Alignment alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    Color bubbleColor = isPlayer2 ? kPink : KDarkGreen;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8,),
              Text(
                senderUsername,
                textAlign: TextAlign.start,
                style: GoogleFonts.shareTech(textStyle: const TextStyle(color: kWhite)),
              ),
            ],
          ),
          ChatBubble(
              text: data['message'], isMe: isMe, bubbleColor: bubbleColor),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
