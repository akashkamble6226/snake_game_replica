import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class HighScoreTile extends StatelessWidget {

  final String docId;
  const HighScoreTile({Key? key,required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // get the collection of highscores

    CollectionReference highScores = FirebaseFirestore.instance .collection('highscores');

    return FutureBuilder<DocumentSnapshot>(
      future: highScores.doc(docId).get(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done)
        {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String , dynamic>;

          return Row(children: [
            Text(data['score'].toString()),
            const SizedBox(width: 10,),
            Text(data['name']),
          ],);
        }
        else
        {
          return const Text('Loading.....');
        }
      },
    );
    
  }
}