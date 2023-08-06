//
//  UpdateSheet.swift
//  
//
//  Created by Andriy Gordiyenko on 8/5/23.
//

import SwiftUI

struct WhatsNewSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    var featuresContainer: FeaturesContainer
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(spacing: 0) {
                    Text("What’s New")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 12)
                    
                    VStack {
                        ForEach(featuresContainer.features) { feature in
                            WhatsNewItem(
                                featuresContainer: featuresContainer,
                                feature: feature
                            )
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    .frame(maxWidth: 400, alignment: .center)
                }
                .padding(.horizontal)
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    dismiss()
                } label: {
                    Text("Continue")
                        .fontWeight(.medium)
                }
                .buttonStyle(HeroButton())
                .padding(.bottom, 12)
                .padding(.top, 32)
                .padding(.horizontal)
                .padding(.horizontal)
                .background(
                    LinearGradient(
                        colors: [
                            Color(uiColor: .systemBackground).opacity(0),
                            Color(uiColor: .systemBackground),
                            Color(uiColor: .systemBackground),
                            Color(uiColor: .systemBackground)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(width: 27, height: 27)
                            Label(
                                "Done",
                                systemImage: "xmark"
                            )
                            .labelStyle(.iconOnly)
                            .font(.footnote)
                            .foregroundColor(Color.secondary)
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            Task {
                await storeView()
            }
        }
    }
    
    
    
    func storeView() async {
        
        guard let releaseId = featuresContainer.releaseId else { return }
        var isDebug: Bool
        #if DEBUG
        isDebug = true
        #else
        isDebug = false
        #endif
        
        let countField: [String: Any] = [ "integerValue": 1 ]
        let isDebugField: [String: Any] = [ "booleanValue": isDebug ]
        let json: [String: Any] = [
            "fields": [
                "count": countField,
                "isDebug": isDebugField
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let interactionId = UUID().uuidString
        let appId = Appeal.shared.configuration.appId
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/uxm-app/databases/(default)/documents/apps-public/\(appId)/releases/\(releaseId)/views?documentId=\(interactionId)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData!
        
        do {
            let (_, _) = try await URLSession.shared.data(for: urlRequest)
        } catch { }
    }
}
