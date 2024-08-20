import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class PollScreenCTL extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> polls = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPollsFromFirestore();
  }

  Future<void> fetchPollsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('polls').get();

      if (querySnapshot.docs.isEmpty) {
        // If no polls exist, create a dummy poll
        await createDummyPoll();
      } else {
        List<Map<String, dynamic>> fetchedPolls = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'question': doc['question'],
            'end_date': (doc['end_date'] as Timestamp)
                .toDate(), // Convert Timestamp to DateTime
            'options': List<Map<String, dynamic>>.from(doc['options']),
          };
        }).toList();

        polls.value = fetchedPolls;
      }
    } catch (e) {
      print("Error fetching polls from Firestore: $e");
    }
  }

  Future<void> createDummyPoll() async {
    try {
      // Create a dummy poll
      Map<String, dynamic> dummyPoll = {
        'question': 'What feature would you like to see next in this app?',
        'end_date':
            DateTime.now().add(Duration(days: 7)), // Poll ends in 7 days
        'options': [
          {'id': 1, 'title': 'New UI design', 'votes': 0},
          {'id': 2, 'title': 'More tutorials', 'votes': 0},
          {'id': 3, 'title': 'Dark mode', 'votes': 0},
          {'id': 4, 'title': 'Performance improvements', 'votes': 0},
        ]
      };

      // Add the dummy poll to Firestore
      DocumentReference newPollRef =
          await firestore.collection('polls').add(dummyPoll);

      // Add the dummy poll to the local list
      polls.add({
        'id': newPollRef.id,
        'question': dummyPoll['question'],
        'end_date': dummyPoll['end_date'],
        'options': dummyPoll['options'],
      });
    } catch (e) {
      print("Error creating dummy poll: $e");
    }
  }

  Future<bool> onVoted(String pollId, String pollOptionId) async {
    try {
      DocumentReference pollRef = firestore.collection('polls').doc(pollId);

      // Fetch the poll document
      DocumentSnapshot pollDoc = await pollRef.get();

      if (pollDoc.exists) {
        developer.log(
            "Poll Exist: Poll ID: $pollId,  Poll Option ID: $pollOptionId");
        List options = pollDoc['options'];
        developer.log("Options: ${options.toString()}");

        int index = options
            .indexWhere((option) => option['id'] == int.parse(pollOptionId));

        if (index != -1) {
          // Increment the vote count
          options[index]['votes'] += 1;

          // Update the poll document in Firestore
          await pollRef.update({'options': options});
          developer.log("Opetions Updated: $options");

          // Update the local polls list
          int pollIndex = polls.indexWhere((poll) => poll['id'] == pollId);
          if (pollIndex != -1) {
            polls[pollIndex]['options'] = options;
            polls.refresh(); // Refresh to update UI
          }

          // If everything succeeded, return true
          return true;
        } else {
          developer.log("Option Not found: $index");

          // Option not found
          return false;
        }
      } else {
        // Poll document not found
        return false;
      }
    } catch (e) {
      print("Error updating vote in Firestore: $e");
      // Return false if there was an error
      return false;
    }
  }
}
