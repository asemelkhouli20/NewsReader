//
//  ViewModel.swift
//  NewsReader
//
//  Created by Asem on 31/07/2023.
//
import SwiftUI
import Realm

class ViewModel:ObservableObject {
    @Published var articles:[Article] = []
    @Published var bookmarks:[Article] = []
    
    @Published var catagory:Category? = Category.general
    @Published var country:Country?
    @Published var search = ""
    @Published var errorMsg:String?
    //Controll View behaviour
    @Published var saved = false
    @Published var isbookmarks = false
    //
    @Published var limit = false
    //
    var isOfflineMood = true
    var page = 2
    
  
    
    func getArticles(pageComplete:Bool=false){
        if isOfflineMood {self.getOffline();return}
        //go next
        page = pageComplete ? (page+1) : 2
        //
        makeArticlesRequset(pageComplete: pageComplete)
    }
    func makeArticlesRequset(pageComplete:Bool,completion: (() -> Void)? = nil){
        let parmaters = makeParmaters(pageComplete)
        DispatchQueue.global(qos: .background).async {
            if let data = Controller_API.shared.getRequest(endPoint: EndPoint.topHeadlines.rawValue, parmaters: parmaters){
                DispatchQueue.main.async {
                    if let result:Articles = self.decodeData(data) {
                        if result.status == .ok {self.okArticlesRequset(result,pageComplete)
                        }else{self.errorMsg = result.message}
                    }
                    if let f = completion{f()}
                }
                
            }else{self.upddateError(.badNetwork)}
        }
    }
   
   
}
extension ViewModel {
    func makeParmaters(_ pageComplete:Bool)->[String:String]{
        var parmaters =  [
            EndValue.q.rawValue : search,
            EndValue.page.rawValue : (pageComplete ? "\(page)" : "1"),
            EndValue.pageSize.rawValue : "40"
        ]
        if let catagory = catagory {parmaters[EndValue.category.rawValue] = catagory.rawValue}
        if let country = country   {parmaters[EndValue.country.rawValue]  = country.rawValue}
        return parmaters
    }
    
    
    func okArticlesRequset(_ result:Articles,_ pageComplete:Bool){
        self.limit = (result.articles?.count == 0) || (result.articles == nil)
        //update data
        if pageComplete {self.articles.append(contentsOf: result.articles ?? [])
        }else{self.articles = result.articles ?? []}
        //save
        try? self.saveToCash()
    }
    

    func upddateError(_ error:ErrorData,completion: (() -> Void)? = nil){
        DispatchQueue.main.async {
            self.errorMsg = error.rawValue
            if let f = completion{f()}
        }
    }
    

}
//MARK: Cash Data
extension ViewModel {
    func saveToCash() throws{
        if let d = encodeData(articles) {
           try Controller_Realm.shared.setCashed(d)
        }
    }
    func getOffline(){
        if let data = Controller_Realm.shared.getCashed()?.cashedData {
            if let result:[Article] = decodeData(data) {self.articles =  result}
        }else{self.upddateError(.faildToLoadDataFromCash)}
    }
}
//MARK: Bookmark Data
extension ViewModel {
    func saveToBookmark(_ article:Article){
        if let d = encodeData(article){
            do{
                try Controller_Realm.shared.saveBookmark(d)
                self.saved = true
            }catch{
                self.upddateError(.faildToSaveTheBookmark)
            }
        }
    }
    func getBookmark(){
        for item in Controller_Realm.shared.getALLBookmark() {
            if let d = item.cashedData {if let result:Article = decodeData(d){bookmarks.append(result)}}
        }
    }
}

//MARK: Codable: encode\decode Data
extension ViewModel {
    func encodeData<T:Codable>(_ d: T)->Data? {
        do{return try JSONEncoder().encode(d)
        }catch{self.upddateError(.badData);return nil}
    }
    func decodeData<T:Codable>(_ data:Data)->T? {
        do{return try JSONDecoder().decode(T.self, from: data)
        }catch{self.upddateError(.badData);return nil}
    }
    func testJSON() -> Data?{
        if let url = Bundle.main.url(forResource: "test", withExtension: "json") {
            let data = try? Data(contentsOf: url)
            return data
            
        }
        return nil
    }
    
}

enum ErrorData:String,CaseIterable {
    case badNetwork = "maybe you have a bad network move to offline mode or retry"
    case badData = "error Bad Data"
    case faildToLoadDataFromCash = "faild to load data from cash Try to connect with network"
    case faildToSaveTheBookmark = "Faild To Save The Bookmark Retry"

}
