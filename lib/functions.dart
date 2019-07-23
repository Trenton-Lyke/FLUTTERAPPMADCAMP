import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';



List getDocumentsByID(CollectionReference collection, List ids, List documents, Function callback){
  if(ids.length > 0){
    collection.document(ids[0]).get().then((doc){
    var docData = doc.data;
    docData["id"] = ids[0];
    documents.add(docData);
    ids.removeRange(0,0);
    return getDocumentsByID( collection, ids, documents, callback);
    });
  }
  else{
    callback(documents);
  }
}


