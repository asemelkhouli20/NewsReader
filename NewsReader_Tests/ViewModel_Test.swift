//
//  ViewModel_Test.swift
//  NewsReader_Tests
//
//  Created by Asem on 07/08/2023.
//

import XCTest
//@testable import NewsReader
@testable import NewsReader
final class ViewModel_Test: XCTestCase {
    let vm = ViewModel()
    
 

    override class func setUp() {
        super.setUp()
      
        
    }
    func test_getArticles_isOfflineMood_page() throws {
        vm.isOfflineMood = true
        vm.getArticles(pageComplete: true)
        XCTAssertNotEqual(vm.articles.count, 0)
        vm.isOfflineMood = false
        vm.page = 5
        vm.getArticles(pageComplete: true)
        XCTAssertEqual(vm.page, 6)
        vm.getArticles(pageComplete: false)
        XCTAssertEqual(vm.page, 2)
    }
    
    func test_getArticles_makeArticlesRequset_pageComplete() throws {
        self.vm.articles = []
        for x in 0..<2 {
            let expectation = expectation(description: "expectation")
            let count = vm.articles.count
            vm.makeArticlesRequset(pageComplete: x==0){
                if self.vm.errorMsg == nil {
                    if x != 0{
                        //pageComplete false
                        XCTAssertNotEqual(self.vm.articles.count, 0)
                    }else{
                        //pageComplete true
                        XCTAssertGreaterThan(self.vm.articles.count, count)
                    }
                }else{
                    XCTFail("check or ignore \(self.vm.errorMsg!)")
                }
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10)
        }
      

    }
    


}
extension ViewModel_Test {
    func test_makeParmaters() throws {
        for _ in 0..<100 {
            vm.page = Int.random(in: 2..<100)
            vm.country = Country.allCases.randomElement()
            vm.catagory = Category.allCases.randomElement()
            vm.search = UUID().uuidString
            let testPage = vm.makeParmaters(false)
            XCTAssertNotEqual(testPage[EndValue.page.rawValue]
                              , "\(vm.page)")
            XCTAssertEqual(testPage[EndValue.category.rawValue]
                           , vm.catagory?.rawValue)
            XCTAssertEqual(testPage[EndValue.country.rawValue]
                           , vm.country?.rawValue)
            XCTAssertEqual(testPage[EndValue.q.rawValue]
                           , vm.search)
        }
        vm.page = 5
        let testPage = vm.makeParmaters(true)
        XCTAssertEqual(testPage[EndValue.page.rawValue]
                          , "\(vm.page)")
        
    }
    func test_okArticlesRequset() throws {
        //Given
        let d = vm.testJSON()
        let result:Articles? = vm.decodeData(d!)
        
        vm.okArticlesRequset(result!, false)
        XCTAssertEqual(vm.limit, false)
        XCTAssertEqual(vm.articles.count, result?.articles?.count)
        vm.okArticlesRequset(result!, true)
        XCTAssertEqual(vm.limit, false)
        XCTAssertEqual(vm.articles.count, ((result?.articles?.count ?? 0)*2))
        result?.articles = []
        vm.okArticlesRequset(result!, true)
        XCTAssertEqual(vm.limit, true)
    }

    func test_upddateError() throws {
        let allError = ErrorData.allCases
        for error in allError {
            let expectation = expectation(description: "expectation")
            vm.upddateError(error) {
                XCTAssertEqual(self.vm.errorMsg, error.rawValue)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1)
        }
    }
}
//MARK: Cash Data
extension ViewModel_Test {
    func test_saveToCash() throws {
        //Given
        let d = vm.testJSON()
        let result:Articles? = vm.decodeData(d!)
        vm.articles = result?.articles ?? []
       
        XCTAssertNoThrow(try vm.saveToCash())
    }
    func test_getOffline() throws {
        vm.articles = []
        vm.getOffline()
        XCTAssertNotEqual(vm.articles.count,0)
    }
    
}
//MARK: Bookmark Data
extension ViewModel_Test {
    func test_saveToBookmark() throws {
        let d = vm.testJSON()
        let result:Articles? = vm.decodeData(d!)
        if let bookmark = result?.articles?.first {
            vm.saveToBookmark(bookmark)
            XCTAssertTrue(vm.saved)
        }else{
            XCTFail("failed make sure about your test code here.")
        }
    }
    
    func test_getBookmark() throws {
        vm.getBookmark()
        XCTAssertNotEqual(vm.bookmarks.count, 0)
    }
}
//MARK: Codable: encode\decode Data
extension ViewModel_Test {
    func test_Codable_Encode_and_Decode_extension_VM(){
        if let d = vm.testJSON() {
            //Decode
            let result:Articles? = vm.decodeData(d)
            XCTAssertNotNil(result)
            XCTAssertNotEqual(result?.articles?.count, 0)
            //Encode
            let e = vm.encodeData(result)
            XCTAssertNotNil(e)
            let dAfterE:Articles? = vm.decodeData(e!)
            XCTAssertNotNil(dAfterE)
            if (dAfterE?.message != result?.message) && (dAfterE?.code != result?.code) {
                XCTFail()
                if dAfterE?.totalResults != result?.totalResults {
                    XCTFail()
                    if dAfterE?.articles?.first?.url != result?.articles?.first?.url {XCTFail()}
                }
            }
            
        }else{
            XCTFail("failed to load json file make sure about your test code there.")
        }
    }
}
