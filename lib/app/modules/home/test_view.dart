import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:slide_maker/app/data/comment.dart';
import 'package:slide_maker/app/data/like.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';

class testView extends StatelessWidget {
  testView({super.key});
final FirestoreService fs = FirestoreService();
Comment comment = Comment(commentId: 5, userId: 2, createdAt: DateTime.now().microsecondsSinceEpoch, text: 'hello world');
Like like = Like(likeId: 5, userId: 6, createdAt: DateTime.now().microsecondsSinceEpoch);
Rx<int> likesCount = 0.obs;
Rx<int> commentsCount = 0.obs;
String presentationId = "1724932321634";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Column(
            children: [
              ElevatedButton.icon(
            onPressed: ()async {
              await fs.addLike(presentationId,like);
              print("${like.userId}");
              int value2 = await fs.fetchLikesCount(presentationId) ;
               likesCount.value = value2;
               int value1 =  await fs.fetchCommentsCount(presentationId);
              commentsCount.value =  value1;
             
            },
           label: Text("Like"),
           icon: Icon(Icons.heart_broken),
           ),
           ElevatedButton.icon(
            onPressed: () async{
              await fs.addComment(presentationId,comment);
                int value2 = await fs.fetchLikesCount(presentationId) ;
               likesCount.value = value2;
               int value1 =  await fs.fetchCommentsCount(presentationId);
              commentsCount.value =  value1;
            },
           label: Text("Comment"),
           icon: Icon(Icons.comment),
           ),
      Container(
       child: Obx(()=>Text("${likesCount.value} ${commentsCount.value}")),
      ),
      
      ElevatedButton.icon(
       onPressed: () async{
        int value1 =  await fs.fetchCommentsCount(presentationId);
       commentsCount.value =  value1;
       print('test $value1 value1');
      }, label: Text("View comments count")
      ),
      ElevatedButton.icon(
       onPressed: () async{
        
        int value2 = await fs.fetchLikesCount(presentationId) ;
       likesCount.value = value2;
       print('test $value2 value2');

      }, label: Text("View likes count")
      )       
            ],
          )
        ],
      ),
      
    );
  }
}
