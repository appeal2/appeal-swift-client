//
//  HeartView.swift
//  
//
//  Created by Andriy Gordiyenko on 7/27/23.
//

import SwiftUI

struct HeartView: View {
    
    let feature: Feature
    let releaseId: String
    
    @State var interactionId: String = ""
    @State var heartsGiven: Int = 0
    
    var heartsTotal: Int {
        var total = 0
        #if DEBUG
        total += feature.heartsDebug
        #else
        total += feature.hearts
        #endif
        total += heartsGiven
        return total
    }
    
    var body: some View {
        Button {
            heartsGiven += 1
        } label: {
            HStack(alignment: .center, spacing: 4) {
                ZStack {
                    ForEach (0..<heartsGiven, id: \.self){ _ in
                        Image(systemName: "heart.fill")
                            .withHeartTapModifier()
                    }
                    Image(systemName: heartsGiven == 0 ? "heart" : "heart.fill")
                }
                Text("\(heartsTotal)")
            }
            .foregroundColor(heartsGiven == 0 ? .secondary : .accentColor)
            .font(.body)
        }
        .onAppear {
            interactionId = UUID().uuidString
        }
        .onDisappear {
            Task {
                await storeHearts()
            }
        }
    }
    
    func storeHearts() async {
        
        if heartsGiven == 0 { return }
        var isDebug: Bool
        #if DEBUG
        isDebug = true
        #else
        isDebug = false
        #endif
        
        let countField: [String: Any] = [ "integerValue": heartsGiven ]
        let isDebugField: [String: Any] = [ "booleanValue": isDebug ]
        let json: [String: Any] = [
            "fields": [
                "count": countField,
                "isDebug": isDebugField
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let appId = Appeal.shared.configuration.appId
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/uxm-app/databases/(default)/documents/apps-public/\(appId)/releases/\(releaseId)/features/\(feature.id)/hearts?documentId=\(interactionId)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData!
    
        let _ = try? await URLSession.shared.data(for: urlRequest)
    }
}

struct HeartsGeometryEffect : GeometryEffect {

    var time : Double
    var speed = Double.random(in: 100 ... 200)
    var xDirection = Double.random(in:  -0.05 ... 0.05)
    var yDirection = Double.random(in: -Double.pi ...  0)

    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * xDirection
        let yTranslation = speed * sin(yDirection) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}

struct HeartTapModifier: ViewModifier {
    @State var time = 0.0
    let duration = 1.0

    func body(content: Content) -> some View {
        ZStack {
            content
                .modifier(HeartsGeometryEffect(time: time))
                .opacity(time == 1 ? 0 : 1)
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
            }
        }
    }
}

extension View {
    func withHeartTapModifier() -> some View {
        self.modifier(HeartTapModifier())
    }
}
