//
//  NoteViewModel.swift
//  noteapp
//
//  Created by Carlos Enrique Gallardo Ambrosio on 14/06/22.
//

import Foundation
import Combine
import FirebaseFirestore

class NoteViewModel: ObservableObject {
    @Published var note: Note
    @Published var modified = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(note: Note = Note(title: "", description: "")){
        self.note = note
        self.$note
            .dropFirst()
            .sink { [weak self] mocie in
                self?.modified = true
            }
                .store(in: &self.cancellables)
    }
    //FireStore
    private var db = Firestore.firestore()
    private func addNote(_ note: Note){
        do {
            let _ = try db.collection("notelist").addDocument(from: note)
        }
        catch {
            print(error)
        }
    }
    private func updateNote(_ note: Note) {
        if let documentId = note.id {
            do {
                try db.collection("notelist").document(documentId).setData(from: note)
            }
            catch {
                print(error)
            }
        }
    }
    private func updateOrAddNote() {
        if let _ = note.id {
            self.updateNote(self.note)
        }
        else {
            addNote(note)
        }
    }
    private func removeNote() {
        if let documentId = note.id {
            db.collection("notelist").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    //UI handlers
    func handleDoneTapped() {
        self.updateOrAddNote()
    }
    func handleDeleteTapped() {
        self.removeNote()
    }
}
