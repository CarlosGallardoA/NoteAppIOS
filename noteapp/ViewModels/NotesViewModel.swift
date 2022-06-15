//
//  NotesViewModel.swift
//  noteapp
//
//  Created by Carlos Enrique Gallardo Ambrosio on 14/06/22.
//

import Foundation
import Combine
import FirebaseFirestore

class NotesViewModel: ObservableObject {
    @Published var notes = [Note]()
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        unsubscribe()
    }
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    func subscribe() {
        if listenerRegistration == nil {
            listenerRegistration = db.collection("notelist").addSnapshotListener { (QuerySnapshot, error ) in
                guard let documents = QuerySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.notes = documents.compactMap { QueryDocumentSnapshot in
                    try? QueryDocumentSnapshot.data(as: Note.self)
                }
            }
        }
    }
}
