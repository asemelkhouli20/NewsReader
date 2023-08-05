//
//  ArticlesScroll.swift
//  NewsReader
//
//  Created by Asem on 01/08/2023.
//
import SwiftUI

struct ArticlesScroll: View {
    
    @EnvironmentObject var viewModel:ViewModel
    var body: some View {
        LazyVStack{
            ForEach(0..<viewModel.articles.count,id: \.self) {i in
                let item = viewModel.articles[i]
                NavigationLink {ArticleDetails(article: item)} label: {ArticleItem(article: item)}
                //limit
                if i == viewModel.articles.count - 1 && !viewModel.limit{
                    ProgressView().onAppear{viewModel.getArticles(pageComplete: true)}
                }
            }.padding()
        }
    }
}
struct BookmarksScroll: View {
    @EnvironmentObject var viewModel:ViewModel
    var body: some View {
        LazyVStack{
            ForEach(0..<viewModel.bookmarks.count,id: \.self) {i in
                let item = viewModel.bookmarks[i]
                NavigationLink {ArticleDetails(article: item)} label: {ArticleItem(article: item)}
            }.padding()
        }
    }
}
