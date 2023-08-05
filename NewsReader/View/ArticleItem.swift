//
//  ArticleItem.swift
//  NewsReader
//
//  Created by Asem on 01/08/2023.
//
import SwiftUI

struct ArticleItem: View {
    var article : Article

    var body: some View {
        VStack(spacing: 15){
            ZStack(alignment: .bottom){
                AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle().foregroundColor(.secondary)
                }
                LinearGradient(gradient: Gradient(colors: [.clear,.blue.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                VStack(alignment: .leading){
                    Text(article.title ?? "").bold().foregroundColor(.white).font(.title2)
                    Color.clear.frame(height: 5)
                }.padding(.leading)
            }.frame(height: 200).clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text(article.description ?? "").multilineTextAlignment(.leading)
                .foregroundColor(Color(uiColor: .label))
            HStack{Spacer();Text("-- ")+Text(article.author ?? "")}
            VStack(alignment: .leading,spacing: 10){
               
                Text("Source: \(article.source?.name ?? "")")
                HStack{Text(article.publishedAt ?? "");Spacer()}
            } .foregroundColor(.secondary).padding(.horizontal)
        }.padding().padding(.bottom)
            .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.5),radius: 5,y:2)
        }
    }
}
