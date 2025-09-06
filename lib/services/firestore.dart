// Step 6: make a service for Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get collection of persons (ใช้อ้างอิงถึง collection persons)
  final CollectionReference persons = FirebaseFirestore.instance.collection(
    'persons',
  );

  // Create
  Future<void> addPerson(String personName, int personAge, String personEmail) {
    return persons.add({
      'personName': personName,
      'personAge': personAge,
      'personEmail': personEmail,
      'timestamp': Timestamp.now(),
    });
  }

  // Read
  Stream<QuerySnapshot> getPersonsStream() {
    final personsStream = persons
        .orderBy('timestamp', descending: true)
        .snapshots();
    return personsStream;
  }

  // Get a person by ID
  Future<Map<String, dynamic>> getPersonById(String personID) async {
    final doc = await FirebaseFirestore.instance
        .collection('persons')
        .doc(personID)
        .get();
    return doc.data() ?? {};
  }

  // Update
  Future<void> updatePerson(
    String personID,
    String personName,
    int personAge,
    String personEmail,
  ) {
    return persons.doc(personID).update({
      'personName': personName,
      'personAge': personAge,
      'personEmail': personEmail,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete
  Future<void> deletePerson(String personID) {
    return persons.doc(personID).delete();
  }
}
