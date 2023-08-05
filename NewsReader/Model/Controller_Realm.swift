//
//  Controller_Realm.swift
//  NewsReader
//
//  Created by Asem on 30/07/2023.
//
import Foundation
import RealmSwift

class Controller_Realm {
   static let shared = Controller_Realm()
   //MARK: Cashed
    func setCashed(_ cash:Data){
        let cashed = CashRelam()
        cashed.time = Date.now
        cashed.cashedData = cash
        cashed._id = UUID().uuidString
        do{
            let realm = try Realm()
            try realm.write {
                let d = realm.objects(CashRelam.self)
                realm.delete(d)
                realm.add(cashed)
            }
        }catch{print(error)}
    }
    func getCashed()->CashRelam?{
        do{
            let realm = try Realm()
            let data = realm.objects(CashRelam.self)
            return data.last
        }catch{print(error)}
        return nil
    }
    //MARK: Bookmark

    func saveBookmark(_ bookmark:Data){
        let cashed = BookmarkRelam()
        cashed.time = Date.now
        cashed.cashedData = bookmark
        cashed._id = UUID().uuidString
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(cashed)
            }
        }catch{print(error)}
    }
    func getALLBookmark()->[BookmarkRelam]{
        do{
            let realm = try Realm()
            let data = realm.objects(BookmarkRelam.self)
            print(data.count)
            return data.shuffled()
        }catch{print(error)}
        return []
    }
    
  
}
