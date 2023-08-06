//
//  WithWhatsNew.swift
//  
//
//  Created by Andriy Gordiyenko on 8/5/23.
//

import SwiftUI

public struct WithWhatsNew: ViewModifier {
    
    @AppStorage("latestShownUpdate") var latestShownUpdate: Int = 0
    
    @State var features: FeaturesContainer? = nil
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                initialize()
            }
            .onChange(of: features) { [features] newValue in
                if features?.id != newValue?.id {
                    Task {
                        await loadImages(for: newValue)
                    }
                }
            }
            .sheet(item: $features) { newValue in
                WhatsNewSheet(
                    featuresContainer: newValue
                )
            }
    }
    
    func initialize() {
        
        let marketingVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let marketingVersionInt = marketingVersionString.toAppealReleaseInt()
        
        #if DEBUG
        if !Appeal.shared.configuration.persistInDebug && marketingVersionInt <= latestShownUpdate {
            return
        }
        #else
        if marketingVersionInt <= latestShownUpdate {
            return
        }
        #endif
        
        Task {
            
            guard let releases = try? await getReleases() else { return }
            guard let closestRelease = releases.first(where: { $0.version <= marketingVersionInt }) else { return }
            
            #if DEBUG
            if !Appeal.shared.configuration.persistInDebug && closestRelease.version <= latestShownUpdate {
                return
            }
            #else
            if theOne.version <= latestShownUpdate {
                return
            }
            #endif
            
            guard let features = try? await getFeatures(for: closestRelease.id) else { return }
            
            DispatchQueue.main.async {
                self.features = features
                latestShownUpdate = closestRelease.version
            }
        }
    }
    
    func getReleases() async throws -> [Release] {
        
        let appId = Appeal.shared.configuration.appId
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/uxm-app/databases/(default)/documents/apps-public/\(appId)/releases")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let releasesContainer = try JSONDecoder().decode(ReleasesContainer.self, from: data)
        let sortedVersions = releasesContainer.releases.sorted(by: { $0.version > $1.version })
        
        return sortedVersions
    }
    
    func getFeatures(for releaseId: String) async throws -> FeaturesContainer {
        
        let appId = Appeal.shared.configuration.appId
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/uxm-app/databases/(default)/documents/apps-public/\(appId)/releases/\(releaseId)/features")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        var featuresContainer = try JSONDecoder().decode(FeaturesContainer.self, from: data)
        featuresContainer.releaseId = releaseId
        
        return featuresContainer
    }
    
    func loadImages(for featuresContainer: FeaturesContainer?) async {
        
        guard let featuresContainer else { return }

        for feature in featuresContainer.features {
            if let url = URL(string: feature.imageUrl),
               let data = try? Data(contentsOf: url)
            {
                DispatchQueue.main.async {
                    let featureImage = FeatureImage(id: feature.id, data: data)
                    withAnimation {
                        self.features?.images.append(featureImage)
                    }
                }
            }
        }
    }
}

public extension View {
    func withWhatsNew() -> some View {
        return self.modifier(WithWhatsNew())
    }
}
