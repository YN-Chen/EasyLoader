//
//  ProfileCardDemo.swift
//  EasyLoaderDemo
//
//  Created by YNC on 2026/11/06.
//

import Foundation
import SwiftUI
import EasyLoader

struct Profile {
    let name: String
    let role: String
    let bio: String

    static let sample = Profile(
        name: "Alex Morgan",
        role: "iOS Developer",
        bio: "Builds small, friendly apps and loves a good loading animation."
    )

    // Fake text that gives the skeleton the right shape while loading.
    static let placeholder = Profile(
        name: "Placeholder name",
        role: "Placeholder role",
        bio: "Placeholder text that is about as long as a real bio would be."
    )
}

struct ProfileCardDemo: View {
    @State private var isLoading = true

    var body: some View {
        VStack(spacing: 24) {
            ProfileCard(profile: isLoading ? .placeholder : .sample)
                .easyLoaderSkeleton(isLoading: isLoading)

            Toggle("Loading", isOn: $isLoading)

            Spacer()
        }
        .padding()
        .navigationTitle("Profile Card")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileCard: View {
    let profile: Profile

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(.headline)
                    Text(profile.role)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text(profile.bio)
                .font(.body)

            Button("Follow") { }
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        ProfileCardDemo()
    }
}
