//
//  ContentView.swift
//  NewsReader
//
//  Created by Asem on 30/07/2023.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel:ViewModel
    
    var body: some View {
        
        NavigationStack{
            ScrollViewReader { scrollProxy in
                ZStack(alignment: .bottom){
                    
                    ScrollView{
                        
                        if viewModel.isbookmarks {
                            BookmarksScroll()
                                .navigationTitle("Bookmarks")
                        }else{
                            if !viewModel.isOfflineMood {
                                VStack(spacing: 20){CustomTextFiled();FillterComponent()}.padding(.horizontal)
                            }
                            //
                            ArticlesScroll()
                                .navigationTitle(EndPoint.topHeadlines.rawValue)
                        }
                        
                    }.refreshable {viewModel.getArticles()}
                    
                    //MARK: Scroll View Reader UP
                    HStack{Spacer();Button {withAnimation {scrollProxy.scrollTo(0)}} label: {ScrollUpButton()}}.padding()
                    
                    //MARK: Catch error and show it to user
                    if let error =  viewModel.errorMsg {Text(error).padding().background(.ultraThinMaterial).onAppear{ClearError()}}
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !viewModel.isbookmarks {viewModel.getBookmark()}
                        viewModel.isbookmarks.toggle()
                    } label: {
                        if viewModel.isbookmarks {Image(systemName: "bookmark.fill")
                        }else{Image(systemName: "bookmark")}
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !viewModel.isbookmarks {
                        Button {
                            viewModel.isOfflineMood.toggle()
                            viewModel.getArticles()
                        } label: {
                            if (viewModel.isOfflineMood) {Image(systemName: "wifi.slash" )}
                            else{Image(systemName: "wifi" )}
                        }
                    }
                }
            }
        }.onAppear{viewModel.getArticles()}
        
    }
    func ClearError(){DispatchQueue.main.asyncAfter(deadline: .now()+3) {withAnimation {viewModel.errorMsg = nil}}}
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ScrollUpButton: View {
    var body: some View {
        Image(systemName: "chevron.up").bold().foregroundColor(.white).padding(25).background{Circle()}
    }
}


/*
 let article = Article(
 source: Source(
 id: "the-wall-street-journal",
 name: "The Wall Street Journal"
 ),
 author: "wsj",
 title: "ALITO: I HAVE TO DEFEND MYSELF...",
 description: "He has emerged as an important justice with a distinctive interpretive method that is pragmatic yet rooted in originalism and textualism.",
 url: "https://www.wsj.com/articles/samuel-alito-the-supreme-courts-plain-spoken-defender-precedent-ethics-originalism-5e3e9a7",
 urlToImage: "https://images.wsj.net/im-825677/social",
 publishedAt: "2023-07-28T20:00:03Z",
 content: "Opinion | Samuel Alito, the Supreme Court’s Plain-Spoken DefenderBy David B. Rivkin Jr. and July 28, 2023 1:57 pm ET New YorkCopyright ©2023 Dow Jones & Company, Inc. All Rights Reserved. 87990cbe85… [+584 chars]"
 )
 */
