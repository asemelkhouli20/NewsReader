//
//  FillterComponent.swift
//  NewsReader
//
//  Created by Asem on 01/08/2023.
//
import SwiftUI

struct FillterComponent: View {
   
    @EnvironmentObject var viewModel:ViewModel
    var body: some View {
        HStack(spacing: 20){
            Menu {
                VStack{
                    Button {viewModel.catagory=nil} label: {HStack{Text("All")}}
                    ForEach(Category.allCases,id: \.self){c in
                        Button {viewModel.catagory=c} label: {
                            HStack{Text(c.rawValue)
                                if viewModel.catagory == c {Image(systemName: "checkmark")}}
                            
                        }
                    }
                }
            } label: {MenuLabel(title: viewModel.catagory?.rawValue)}
            Menu {
                VStack{
                    Button {viewModel.country=nil} label: {HStack{Text("All")}}
                    ForEach(Country.allCases,id: \.self){c in
                        Button {viewModel.country=c} label: {
                            HStack{Text(c.rawValue)
                                if viewModel.country == c {Image(systemName: "checkmark")}}
                            
                        }
                    }
                }
            } label: {MenuLabel(title: viewModel.country?.rawValue)}
        }.padding(.horizontal)
            .onChange(of: viewModel.catagory) { _ in viewModel.getArticles()}
            .onChange(of: viewModel.country) { _ in viewModel.getArticles()}
    }
}


struct MenuLabel: View {
    var title:String?
    var body: some View {
        HStack{Text(title ?? "ALL");Image(systemName: "chevron.down")}
            .foregroundColor(.blue).bold().padding(.horizontal,20).padding(.vertical,8)
            .frame(maxWidth: .infinity)
            .background {RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(.blue)}
    }
}
