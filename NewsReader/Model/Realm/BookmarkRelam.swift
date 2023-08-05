//
//  BookmarkRelam.swift
//  NewsReader
//
//  Created by Asem on 01/08/2023.
//

import Foundation
import RealmSwift

class BookmarkRelam: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var time: Date?
    @Persisted var cashedData: Data?
}
