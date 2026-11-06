//
//  ContentView.swift
//  EasyLoaderDemo
//
//  Created by YNC on 2026/11/06.
//

import SwiftUI
import EasyLoader

struct ContentView: View {
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            List {
                Section("Full-screen loader") {
                    Button("Show for 3 seconds") {
                        isLoading = true
                        Task {
                            try? await Task.sleep(for: .seconds(3))
                            isLoading = false
                        }
                    }
                }

                Section("Skeleton") {
                    NavigationLink("Profile card") {
                        ProfileCardDemo()
                    }
                    NavigationLink("Message list") {
                        MessageListDemo()
                    }
                }
            }
            .navigationTitle("EasyLoader")
        }
        .easyLoaderFull(isPresented: isLoading, message: "Loading…")
    }
}

#Preview {
    ContentView()
}
