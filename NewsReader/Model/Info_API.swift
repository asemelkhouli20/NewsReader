//
//  Info_API.swift
//  NewsReader
//
//  Created by Asem on 30/07/2023.
//

import UIKit

//this Constent it just for testing
struct Info_API {
    static var semaphore = DispatchSemaphore (value: 0)
    //MARK: - Base URL
    static let baseURL = "https://newsapi.org/v2/"
    //for send normal data
    static let spaceRN = "\"\r\n\r\n"
    static let RN = "\r\n"
    static let con = "\r\nContent-Disposition:form-data; name=\""
    //For give header ID Track it
    static let boundaryRN = "multipart/form-data; boundary="
    //upload image
    static let imagName = "\"; filename=\"image123.jpeg\"\r\nContent-Type: file\r\n\r\n"
}


//MARK: - End Piont
enum EndPoint : String {
    case everything
    case topHeadlines = "top-headlines"
}
//MARK: - End Piont
enum EndValue : String {
    //avalible in all
    case q              // Keywords or phrases to search for in the article title and body.
    case sources       // Use the /sources endpoint to locate these programmatically or look at the sources index.
    case pageSize     // Default: 100. Maximum: 100.
    case page        // Default: 1.
    
    //avalible only in everything
    case excludeDomains  // (eg bbc.co.uk, techcrunch.com, engadget.com) to
    case searchIn       // title,description,content
    case sortBy        // Check down MARK-EndValue.sortBy
    case language     // Possible options: MARK-enum Language.
    case from        // e.g. 2023-07-30 or 2023-07-30T21:27:07)
    case to         // e.g. 2023-07-30 or 2023-07-30T21:27:07)
    case domains   // (eg bbc.co.uk, techcrunch.com, engadget.com) to
    
    //avalible only in topHeadlines
    case country    //  Possible options: MARK-enum Country.  Note: you can't mix this param with the sources param.
    case category // Possible options: MARK-enum Category. Note: you can't mix this param with the sources param.
    
}

//MARK: - End Piont
enum CallType : String {
    case get = "GET"
    case post = "POST"
}

//MARK: - getObjectData
func getObjectData(image Object_Image:[String:UIImage],info ObjectInfo:[String:String],boundary:String)->Data {
    var data = Data()
    for item in ObjectInfo {
        let value = item.key+Info_API.spaceRN+item.value+Info_API.RN
        data.append("\r\n--\(boundary+Info_API.con)".data(using: .utf8)!)
        data.append(value.data(using: .utf8)!)}
    for item in Object_Image {
        let value = item.key+Info_API.imagName
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary+Info_API.con)".data(using: .utf8)!)
        data.append(value.data(using: .utf8)!)
        data.append(item.value.jpegData(compressionQuality: 0.6)!)
    }
    if ObjectInfo.isEmpty {data.append(Info_API.RN.data(using: .utf8)!)}
    data.append("--\(boundary)--\r\n".data(using: .utf8)!)
    // print(String(data: data, encoding: .utf8))
    
    return data
    
}

//MARK: - EndValue.sortBy
/*
 The order to sort the articles in. Possible options: MARK- enum SortBy.
 relevancy = articles more closely related to q come first.
 popularity = articles from popular sources and publishers come first.
 publishedAt = newest articles come first.
 Default: publishedAt
 */

//MARK: - SortBy
enum SortBy : String {case relevancy, popularity, publishedAt}
//MARK: - Language
enum Language : String {case ar,de,en,es,fr,he,it,nl,no,pt,ru,sv,ud,zh}

//MARK: - Category
enum Category : String,CaseIterable {case business,entertainment,general,health,science,sports,technology}
//MARK: - Country
enum Country : String,CaseIterable {
    case ae,ar,at,au,be,bg,br,ca,ch,cn,co,cu,cz,de,eg,fr,gb
    case gr,hk,hu,id,ie,il,it,jp,kr,lt,lv,ma,mx,my,ng,nl,no
    case nz,ph,pl,pt,ro,rs,ru,sa,se,sg,si,sk,th,tr,tw,ua,us,ve,za
    case IN = "in"
}

//MARK: - Handel error
/*
 TODO: - Handel it if you have time
 HTTP status codes summary
 200 - OK. The request was executed successfully.
 400 - Bad Request. The request was unacceptable, often due to a missing or misconfigured parameter.
 401 - Unauthorized. Your API key was missing from the request, or wasn't correct.
 429 - Too Many Requests. You made too many requests within a window of time and have been rate limited. Back off for a while.
 500 - Server Error. Something went wrong on our side.
 */
 
//MARK: - ErrorCode
enum ErrorCode : String {
   //  When an HTTP error is returned we populate the code and message properties in the response containing more information.
    //Here are the possible options:
   
     case apiKeyDisabled
    //- Your API key has been disabled.
    
     case apiKeyExhausted
    //- Your API key has no more requests available.
    
     case apiKeyInvalid
    //- Your API key hasn't been entered correctly. Double check it and try again.
    
     case apiKeyMissing
    //- Your API key is missing from the request. Append it to the request with one of these methods.
    
     case parameterInvalid
    //- You've included a parameter in your request which is currently not supported. Check the message property for more details.
    
     case parametersMissing
    //- Required parameters are missing from the request and it cannot be completed. Check the message property for more details.
    
     case rateLimited
    //- You have been rate limited. Back off for a while before trying the request again.
    
     case sourcesTooMany
    //- You have requested too many sources in a single request. Try splitting the request into 2 smaller requests.
    
     case sourceDoesNotExist
    //- You have requested a source which does not exist.
    
     case unexpectedError
    //- This shouldn't happen, and if it does then it's our fault, not yours. Try the request again shortly.
    
}

