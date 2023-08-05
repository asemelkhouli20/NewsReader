//
//  NewsReaderApp.swift
//  NewsReader
//
//  Created by Asem on 30/07/2023.
//
import SwiftUI

@main
struct NewsReaderApp: App {
    @StateObject var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
