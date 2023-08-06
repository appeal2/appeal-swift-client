//
//  FeatureImageView.swift
//  
//
//  Created by Andriy Gordiyenko on 7/27/23.
//

import SwiftUI

struct FeatureImageView: View {
    
    let image: FeatureImage?
    
    let imageSize: CGFloat = 48
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(Color(uiColor: .clear))
                .frame(width: imageSize, height: imageSize)
                .opacity(0.01)
            
            if let image,
               let uiImage = UIImage(data: image.data)
            {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .transition(.scale(scale: 1.2).combined(with: .opacity))
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: imageSize, height: imageSize)
            }
        }
    }
}
