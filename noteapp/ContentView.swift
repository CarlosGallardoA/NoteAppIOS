//
//  ContentView.swift
//  noteapp
//
//  Created by Carlos Enrique Gallardo Ambrosio on 14/06/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = NotesViewModel()
    @State var presentAddNoteSheet = false
    private var addButtom: some View {
        Button(action: { self.presentAddNoteSheet.toggle() }){
            Image(systemName: "plus")
        }
    }
    private func noteRowView(note: Note) -> some View {
        NavigationLink(destination: NoteDetailsView(note: note)){
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.headline)
                Text(note.description)
                    .font(.subheadline)
            }
        }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach (viewModel.notes) { note in
                    noteRowView(note: note)
                }
            }
            .navigationBarTitle("Note")
            .navigationBarItems(trailing: addButtom)
            .onAppear(){
                print("NotesListView appears. Subscribing to data updates.")
                self.viewModel.subscribe()
            }
            .sheet(isPresented: self.$presentAddNoteSheet) {
                NoteEditView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
