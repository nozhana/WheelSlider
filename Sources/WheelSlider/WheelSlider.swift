//
//  WheelSlider.swift
//  WheelSlider
//
//  Created by Nozhan Amiri on 1/4/25.
//

import SwiftUI

public struct WheelSlider<Value: BinaryFloatingPoint>: View {
    @Binding public var value: Value
    private let range: ClosedRange<Value>
    private let stepCount: Int
    private let snap: Bool
    private let axis: Axis
    
    private var step: Value {
        (range.upperBound - range.lowerBound) / Value(stepCount)
    }

    @State private var scrollPosition: Int?
    
    public init(value: Binding<Value>, in range: ClosedRange<Value>, step: Value, snap: Bool = true, axis: Axis = .horizontal) {
        self._value = value
        self.range = range
        self.stepCount = Int((range.upperBound - range.lowerBound) / step)
        self.snap = snap
        self.axis = axis
    }
    
    public init(value: Binding<Value>, in range: ClosedRange<Value>, stepCount: Int = 10, snap: Bool = true, axis: Axis = .horizontal) {
        self._value = value
        self.range = range
        self.stepCount = stepCount
        self.snap = snap
        self.axis = axis
    }
    
    private var horizontalSlider: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: geometry.size.width / 2 - 16, height: 16)
                        
                        HStack(spacing: 0) {
                            ForEach(0..<stepCount+1) { index in
                                let isFifth = index % 5 == 0
                                Rectangle()
                                    .fill(.primary.opacity(isFifth ? 1 : 0.75))
                                    .frame(width: 1, height: isFifth ? 16 : 12)
                                    .frame(width: 16)
                                    .scrollTransition(.animated(.easeOut(duration: 0.25).delay(0.1)).threshold(.visible(0.9))) { content, phase in
                                        content
                                            .scaleEffect(phase.isIdentity ? 1 : 0.5)
                                            .opacity(phase.isIdentity ? 1 : 0.5)
                                    }
                                    .scrollTransition(.animated(.easeOut(duration: 0.25)).threshold(.centered)) { content, phase in
                                        content
                                            .scaleEffect(x: 1, y: phase.isIdentity ? 2 : 1)
                                            .offset(y: phase.isIdentity ? -4 : 0)
                                    }
                                    .id(index)
                            } // ForEach
                        } // HStack
                        .scrollTargetLayout()
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: geometry.size.width / 2 - 16, height: 16)
                    } // HStack
                } // ScrollView
                .scrollIndicators(.never)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrollPosition, anchor: .center)
                .onChange(of: scrollPosition) { _, newPosition in
                    guard let newPosition else { return }
                    let snapValue = Value(newPosition) * step + range.lowerBound
                    value = snapValue
                }
                .onAppear {
                    let valueStep = Int((value - range.lowerBound) / step)
                    proxy.scrollTo(valueStep, anchor: .center)
                }
                .sensoryFeedback(.selection, trigger: scrollPosition)
            } // ScrollViewReader
        } // GeometryReader
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.yellow)
                .frame(width: 2, height: 22)
        }
        .contentShape(.rect)
        .frame(height: 34)
    }
    
    private var verticalSlider: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 16, height: geometry.size.height / 2 - 15)
                        
                        VStack(spacing: 0) {
                            ForEach(0..<stepCount+1) { index in
                                let isFifth = index % 5 == 0
                                Rectangle()
                                    .fill(.primary.opacity(isFifth ? 1 : 0.75))
                                    .frame(width: isFifth ? 16 : 12, height: 1)
                                    .frame(height: 17)
                                    .scrollTransition(.animated(.easeOut(duration: 0.25).delay(0.1)).threshold(.visible(0.9))) { content, phase in
                                        content
                                            .scaleEffect(phase.isIdentity ? 1 : 0.5)
                                            .opacity(phase.isIdentity ? 1 : 0.5)
                                    }
                                    .scrollTransition(.animated(.easeOut(duration: 0.25)).threshold(.centered)) { content, phase in
                                        content
                                            .scaleEffect(x: phase.isIdentity ? 2 : 1, y: 1)
                                            .offset(x: phase.isIdentity ? 4 : 0)
                                    }
                                    .id(index)
                            } // ForEach
                        } // VStack
                        .scrollTargetLayout()
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 16, height: geometry.size.height / 2 - 15)
                    } // VStack
                } // ScrollView
                .scrollIndicators(.never)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrollPosition, anchor: .center)
                .onChange(of: scrollPosition) { _, newPosition in
                    guard let newPosition else { return }
                    let snapValue = Value(newPosition) * step + range.lowerBound
                    value = snapValue
                }
                .onAppear {
                    let valueStep = Int((value - range.lowerBound) / step)
                    
                    if valueStep < stepCount {
                        proxy.scrollTo(valueStep, anchor: .center)
                    }
                }
                .sensoryFeedback(.selection, trigger: scrollPosition)
            } // ScrollViewReader
        } // GeometryReader
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(.yellow)
                .frame(width: 22, height: 2)
                .offset(y: 2)
        }
        .contentShape(.rect)
        .frame(width: 26)
    }
    
    public var body: some View {
        switch axis {
        case .horizontal:
            horizontalSlider
        case .vertical:
            verticalSlider
        }
    }
}
