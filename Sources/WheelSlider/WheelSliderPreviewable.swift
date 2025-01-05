//
//  WheelSliderPreviewable.swift
//  WheelSlider
//
//  Created by Nozhan Amiri on 1/5/25.
//

import SwiftUI

struct WheelSliderPreviewable: View {
    @State private var value: Double = 5
    
    var body: some View {
        VStack {
            Text(value.formatted())
                .font(.title.bold())
            
            WheelSlider(value: $value, in: 0...30, step: 0.5)
                .overlay(alignment: .bottom) {
                    Text(value.formatted())
                        .font(.caption)
                        .foregroundStyle(.yellow)
                        .offset(y: 8)
                }
                .padding()
        }
    }
}

#Preview {
    WheelSliderPreviewable()
}
