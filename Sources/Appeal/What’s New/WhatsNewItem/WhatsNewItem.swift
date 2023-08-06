//
//  WhatsNewItem.swift
//  
//
//  Created by Andriy Gordiyenko on 7/31/23.
//

import SwiftUI

struct WhatsNewItem: View {
    
    let featuresContainer: FeaturesContainer
    let feature: Feature
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            
            let image = featuresContainer.images.first(where: { $0.id == feature.id })
            
            FeatureImageView(image: image)
                .padding(.trailing, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(feature.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 2)
                
                Text(feature.body)
                    .font(.body)
                    .padding(.top, 8)
                
                if let releaseId = featuresContainer.releaseId {
                    HeartView(
                        feature: feature,
                        releaseId: releaseId
                    )
                    .padding(.top, 12)
                }
            }
            .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 32)
    }
}
