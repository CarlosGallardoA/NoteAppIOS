//
//  Note.swift
//  noteapp
//
//  Created by Carlos Enrique Gallardo Ambrosio on 14/06/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
    }
}

