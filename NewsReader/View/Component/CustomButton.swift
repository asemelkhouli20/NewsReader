//
//  CustomButton.swift
//  NewsReader
//
//  Created by Asem on 01/08/2023.
//
import SwiftUI

struct CustomButton: View {
    var title : String
    
    var body: some View {
        Text(title).bold()
            .foregroundColor(Color(uiColor: .white))
            .padding()
            .frame(maxWidth: .infinity)
            .background {RoundedRectangle(cornerRadius: 8)}.padding()
    }
}
