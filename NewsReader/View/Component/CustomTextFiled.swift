//
//  CustomTextFiled.swift
//  NewsReader
//
//  Created by Asem on 01/08/2023.
//
import SwiftUI

struct CustomTextFiled: View {
    @EnvironmentObject var viewModel:ViewModel
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Look for something", text: $viewModel.search).font(Font.system(size: 21))
        }
        .padding(7)
        .background{
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("searchBarColor"))
            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5).opacity(0.5)
                .foregroundColor(.blue)
        } .onChange(of: viewModel.search) { _ in viewModel.getArticles()}
    }
}
