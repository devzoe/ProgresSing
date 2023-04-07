//
//  RankingDataManager.swift
//  UpSing
//
//  Created by 남경민 on 2023/03/30.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

final class RankingDataManager {
    
    private var documentListener: ListenerRegistration?
    
    func createRanking(_ ranking: Ranking, completion: ((Error?) -> Void)? = nil) {
        let collectionPath = "scores"
        let collectionListener = Firestore.firestore().collection(collectionPath)
       
        guard let dictionary = ranking.asDictionary else {
            print("decode error")
            return
        }
        collectionListener.addDocument(data: dictionary) { error in
            completion?(error)
        }
    }

    func readRanking(delegate: SettingViewController) {
        let collectionPath = "scores"
        removeListener()
        let collectionListener = Firestore.firestore().collection(collectionPath)
        var rankings = [Ranking]()
        /*
        documentListener = collectionListener
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    //completion(.failure(FirestoreError.firestoreError(error)))
                    return
                }
                
                var rankings = [Ranking]()
                snapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added, .modified:
                        do {
                            if let ranking = try change.document.data(as: Ranking.self) {
                                rankings.append(ranking)
                            }
                        } catch {
                            //completion(.failure(.decodedError(error)))
                        }
                    default: break
                    }
                }
                //completion(.success(rankings))
            }
         */
        collectionListener.order(by: "score", descending: true).getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     
                     for document in querySnapshot!.documents {
                         print("\(document.documentID) => \(document.data())")
                         do {
                             let ranking = try document.data(as: Ranking.self)
                             rankings.append(ranking)
                         } catch {
                             print("Error getting documents: \(err)")
                         }
                     }
                     delegate.didSuccess(ranking : rankings)
                 }
                
             }
        
        
    }
    
    func removeListener() {
        documentListener?.remove()
    }
}
