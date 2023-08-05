//
//  Articles.swift
//  NewsReader
//
//  Created by Asem on 30/07/2023.
//
import Foundation
// MARK: - Articles
class Articles: Codable {
    var status: Status?
    var totalResults: Int?
    var articles: [Article]?
    //if Status == .error
    var code,message:String?

}

// MARK: - Article
struct Article: Codable {
    var source: Source?
    var author, title, description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
}

// MARK: - Source
struct Source: Codable {var id,name: String?}


enum Status: String, Codable {case ok,error}

