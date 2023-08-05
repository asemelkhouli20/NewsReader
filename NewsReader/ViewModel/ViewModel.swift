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
    //
    let badNetwork = "maybe you have a bad network move to offline mode or retry"
    let badData = "error Bad Data"
    //
    
    func getArticles(pageComplete:Bool=false){
        //
        if isOfflineMood {self.getOffline();return}
        //
        
        var parmaters =  [
            EndValue.q.rawValue : search,
            EndValue.page.rawValue : (pageComplete ? "\(page)" : "1"),
            EndValue.pageSize.rawValue : "40"
        ]
        if let catagory = catagory {parmaters[EndValue.category.rawValue] = catagory.rawValue}
        if let country = country   {parmaters[EndValue.country.rawValue]  = country.rawValue}
        
        //go next
        page = pageComplete ? (page+1) : 2
        //
        
        DispatchQueue.global(qos: .background).async {
            if let data = Controller_API.shared.getRequest(endPoint: EndPoint.topHeadlines.rawValue, parmaters: parmaters){
                do{
                    let result = try JSONDecoder().decode(Articles.self, from: data)
                    DispatchQueue.main.async {
                        if result.status == .ok {
                            self.limit = (result.articles?.count == 0) || (result.articles == nil)
                            if pageComplete {
                                self.articles.append(contentsOf: result.articles ?? [])
                            }else{
                                self.articles = result.articles ?? []
                                Controller_Realm.shared.setCashed(data)
                            }
                            
                        }else{self.errorMsg = result.message}
                    }
                }catch{
                    print(error)
                    DispatchQueue.main.async {self.errorMsg = self.badData}
                }
            }else{
                DispatchQueue.main.async {self.errorMsg = self.badNetwork}
            }
        }
    }
    func getOffline(){
        if let data = Controller_Realm.shared.getCashed(),data.cashedData != nil {
            do{
                let result = try JSONDecoder().decode(Articles.self, from: data.cashedData!)
                self.articles=result.articles ?? []
            }catch{
                print(error)
            }
        }
    }
    func saveToBookmark(_ article:Article){
        do{
            let data = try JSONEncoder().encode(article)
            Controller_Realm.shared.saveBookmark(data)
            self.saved = true
        }catch{print(error)}
    }
    func getBookmark(){
        for item in Controller_Realm.shared.getALLBookmark() {
            do{
                let result = try JSONDecoder().decode(Article.self, from: item.cashedData!)
                bookmarks.append(result)
            }catch{
                print(error)
            }
        }
    }
    
    
}
