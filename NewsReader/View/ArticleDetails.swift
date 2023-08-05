//
//  ArticleDetails.swift
//  NewsReader
//
//  Created by Asem on 01/08/2023.
//
import SwiftUI

struct ArticleDetails: View {
    var article : Article
    @State private var isPresentWebView = false
    @EnvironmentObject var viewModel:ViewModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
                .ignoresSafeArea()
            ScrollView{
                DetailsImageComponent(image: article.urlToImage ?? "", title: article.title ?? "").frame(height: 300)
                VStack{
                    VStack(spacing: 15){
                        Text(article.description ?? "")
                        Rectangle().frame(height: 0.5).foregroundColor(.secondary)
                        Text(article.content ?? "")
                        HStack{Spacer();Text("-- ")+Text(article.author ?? "")}
                    }.padding()
                    
                    VStack(alignment: .leading,spacing: 15){
                        Text("Source: \(article.source?.name ?? "")")
                        HStack{Text(article.publishedAt ?? "");Spacer()}
                    } .foregroundColor(.secondary).padding(.horizontal)
                }.multilineTextAlignment(.leading)
         
                NavigationLink {
                    WebView(url: URL(string: article.url ?? ""))
                        .ignoresSafeArea()
                        .navigationTitle(article.title ?? "")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {CustomButton(title: "Read more")}
            }.onAppear{viewModel.saved = false}
            
        }.edgesIgnoringSafeArea(.top)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.saved || viewModel.isbookmarks{
                        Button {
                            //do something
                        } label: {Image(systemName: "bookmark.fill")
                        }
                    }else{
                        Button {viewModel.saveToBookmark(article)
                        } label: {Image(systemName: "bookmark")}
                    }
                }
            }
        
    }
}
struct DetailsImageComponent: View {
    var image,title : String
   
    var body: some View {
        ZStack(alignment: .bottom){
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
            } placeholder: {Rectangle().foregroundColor(.secondary)}
            LinearGradient(gradient: Gradient(colors: [.clear,.blue.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading){
                Text(title).bold().foregroundColor(.white)
                    .font(.title2)
                Color.clear.frame(height: 5)
            }.padding(.leading)
        }
    }
}
