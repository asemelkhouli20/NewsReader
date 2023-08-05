//
//  Controller_API.swift
//  NewsReader
//
//  Created by Asem on 30/07/2023.
//
import Foundation
import CoreVideo
import UIKit
import Alamofire

class Controller_API {
    var semaphore = DispatchSemaphore (value: 0)
    var token:String?
    var headers: HTTPHeaders = [
        "Accept": "application/json",
        "Accept-Language" :"ar",
        "locale":"en",
        //TODO: Put_Your_API_Key_Here (https://newsapi.org)
        "Authorization":"Put_Your_API_Key_Here"
    ]

    static let shared = Controller_API()
    //MARK: Start Request
    static func startRequest<T: Codable>(endPoint:String,_ image:[String:UIImage],_ dataSend:[String:String],_ type:CallType,token:String?=nil) -> T?{
        var value:T?
        //1 makeRequest
        
        let request = shared.makeRequest(endPoint, image, dataSend, type,token ?? Controller_API.shared.token)
        //2 MakeCall
        if let data = shared.makeCall(request) {
            //decode
            do{value = try JSONDecoder().decode(T.self, from: data)}
            catch{
                print("decode faild")
                if let json = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String : Any] {print(json)}
            }
        }
        return value
    }
    //MARK: 1- makeRequest
    func makeRequest (_ EndURL:String,_ image:[String:UIImage],_ dataSend:[String:String],_ type:CallType,_ tokenS:String?=nil) -> URLRequest {
        var request = URLRequest(url: URL(string: Info_API.baseURL+EndURL)!)
        request.httpMethod = type.rawValue
        //make body and header for Post Type
        if type == .post {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.addValue(Info_API.boundaryRN+boundary, forHTTPHeaderField: "Content-Type")
            request.httpBody = getObjectData(image: image, info: dataSend, boundary: boundary)
        }
        request.addValue("en", forHTTPHeaderField: "lang")
        //add token if we need it
        var tokenSend = ""
        if let tokenSen = tokenS{tokenSend = "Bearer"+tokenSen}
        else{tokenSend = "Bearer"+(self.token ?? "")}
        request.addValue(tokenSend, forHTTPHeaderField: "Authorization")
        return request
    }
    
    //MARK: 2- MakeCall
    func makeCall (_ request:URLRequest) -> Data? {
        var value:Data?
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let dataLoad = data {
                value = dataLoad
                print("Sucess Load data from requet")
            }else{
                print("320 Network error:- data is nil:")
                print(error?.localizedDescription ?? "error nil")
            }
            self.semaphore.signal()
        }
        task.resume()
        print(String(data: value ?? Data(), encoding: .utf8) ?? "")
        self.semaphore.wait()
        return value
    }
    
   
    func getRequest(endPoint:String,parmaters:[String:String])->Data?{
        var value:Data?
        var endParmater = "?"
        for p in parmaters {endParmater += (p.key + "=" + p.value + "&")}
        endParmater.removeLast()
        let url = Info_API.baseURL + endPoint + endParmater
        let endURL = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        
//        headers["Authorization"] = "Bearer \(Controller_API.shared.token ?? "")"
        print(url)
        AF.request(endURL ?? "",method: .get,headers: headers).validate().response {response in
            value = response.data
//            switch response.result {
//            case .success: value = response.data
//            case let .failure(error): print(error)}
            self.semaphore.signal()
        }
        self.semaphore.wait()
        return value
    }
    func postRequest(endPoint:String,parm:[String: Any],uploadedimages:[String:UIImage] = [:])->Data?  {
         var value:Data?
//        headers["Authorization"] = "Bearer \(Controller_API.shared.token ?? "")"
        AF.upload(multipartFormData: { multiPart in
            for p in parm {
                print("key: \(p.key) , value: \(p.value)")
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            print(multiPart)
            for img in uploadedimages {
                multiPart.append((img.value.jpegData(compressionQuality: 0.2))!, withName: "\(img.key )", fileName: "image\(img.key ).jpg", mimeType: "image/*")
            }
            
        }, to: Info_API.baseURL + endPoint, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).response { (response) in
            
            switch response.result {
            case .success(_):
                if response.response?.statusCode == 400{
                    if let d = response.data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: d, options : .allowFragments) as? [String : Any] {
                                if let msg = json["errors"] as?  String  {print(msg)}
                            }
                        }
                        catch {print("Exception converting: \(error)")}
                    }
                }
                else if response.response?.statusCode == 200{
                    if let d = response.data {value = d}
                }
            case .failure(let err):print(err)
            }
            self.semaphore.signal()
        }
        self.semaphore.wait()
        return value
    }
   
    
  
}
