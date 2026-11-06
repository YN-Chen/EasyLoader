//
//  MessageListDemo.swift
//  EasyLoaderDemo
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI
import EasyLoader

struct Message: Identifiable {
    let id: Int
    let sender: String
    let preview: String

    static let samples = [
        Message(id: 0, sender: "Sam", preview: "Are we still on for lunch tomorrow?"),
        Message(id: 1, sender: "Priya", preview: "I sent over the new designs."),
        Message(id: 2, sender: "Jordan", preview: "The build passed, nice work!"),
        Message(id: 3, sender: "Lee", preview: "Can you review my pull request?"),
        Message(id: 4, sender: "Maria", preview: "Happy birthday! Hope it's a great one."),
        Message(id: 5, sender: "Chris", preview: "Running ten minutes late, sorry."),
        Message(id: 6, sender: "Taylor", preview: "Here's the link I mentioned earlier."),
        Message(id: 7, sender: "Robin", preview: "Thanks for your help today!")
    ]

    // Fake rows that give the skeleton the right shape while loading.
    static let placeholders = (0..<8).map { index in
        Message(id: index, sender: "Placeholder", preview: "Placeholder message preview text")
    }
}

struct MessageListDemo: View {
    @State private var isLoading = true

    var body: some View {
        List {
            Section {
                Toggle("Loading", isOn: $isLoading)
            }

            Section("Messages") {
                ForEach(isLoading ? Message.placeholders : Message.samples) { message in
                    MessageRow(message: message)
                }
                .easyLoaderSkeleton(isLoading: isLoading)
            }
        }
        .navigationTitle("Message List")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(message.sender)
                    .font(.headline)
                Text(message.preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MessageListDemo()
    }
}
