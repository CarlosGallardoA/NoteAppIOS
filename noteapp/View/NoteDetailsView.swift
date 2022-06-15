//
//  NoteDetailsView.swift
//  noteapp
//
//  Created by Carlos Enrique Gallardo Ambrosio on 14/06/22.
//

import SwiftUI

struct NoteDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditNoteSheet = false
    var note: Note
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
            Text("Edit")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Note")) {
                Text(note.title)
            }
            Section(header: Text("Description"))  {
                Text(note.description)
            }
    }
        .navigationBarTitle(note.title)
        .navigationBarItems(trailing: editButton {
            self.presentEditNoteSheet.toggle()
        })
        .onAppear() {
            print("MovieDetailsView.onAppear() for \(self.note.title)")
        }
        .onDisappear() {
            print("MovieDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditNoteSheet) {
            NoteEditView(viewModel: NoteViewModel(note: note), mode: .edit)
        }
    }
}

struct NoteDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let note = Note(title: "title note", description: "description note")
        return
            NavigationView {
                NoteDetailsView(note: note)
        }
    }
}
