//
//  NoteEditView.swift
//  noteapp
//
//  Created by Carlos Enrique Gallardo Ambrosio on 14/06/22.
//

import SwiftUI
enum Mode {
    case new
    case edit
}
enum Action {
    case delete
    case done
    case cancel
}
struct NoteEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    @ObservedObject var viewModel = NoteViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    var cancelButton: some View {
        Button(action: { self.handleCancelTapped() }) {
            Text("Cancel")
        }
    }
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Done" : "Save")
        }
        .disabled(!viewModel.modified)
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Note")) {
                    TextField("Title", text: $viewModel.note.title)
                }
                Section(header: Text("Description")){
                    TextField("Description", text: $viewModel.note.description)
                }
                if mode == .edit {
                    Section {
                        Button("Delete Note") { self.presentActionSheet.toggle() }
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(mode == .new ? "New Note": viewModel.note.title)
            .navigationBarTitleDisplayMode(mode == .new ? .inline: .large)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
            .actionSheet(isPresented: $presentActionSheet) {
                ActionSheet(title: Text("Are you sure?"),
                buttons: [
                    .destructive(Text("Delete Note"), action: { self.handleDeleteTapped() }),
                    .cancel()
                ])
            }
        }
    }
    // button actions
    func handleCancelTapped() {
        self.dismiss()
    }
    func handleDoneTapped() {
        self.viewModel.handleDoneTapped()
        self.dismiss()
    }
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NoteEditView_Previews: PreviewProvider {
    static var previews: some View {
        let note = Note(title: "sample title", description: "sample description")
        let noteViewModel = NoteViewModel(note: note)
        return NoteEditView(viewModel: noteViewModel, mode: .edit)

    }
}
