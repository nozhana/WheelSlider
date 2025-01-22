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
    private let curved: Bool
    private let axis: Axis
    
    private var step: Value {
        (range.upperBound - range.lowerBound) / Value(stepCount)
    }

    @State private var scrollPosition: Int?
    
    public init(value: Binding<Value>, in range: ClosedRange<Value>, step: Value, curved: Bool = true, axis: Axis = .horizontal) {
        self._value = value
        self.range = range
        self.stepCount = Int((range.upperBound - range.lowerBound) / step)
        self.curved = curved
        self.axis = axis
    }
    
    public init(value: Binding<Value>, in range: ClosedRange<Value>, stepCount: Int = 10, curved: Bool = true, axis: Axis = .horizontal) {
        self._value = value
        self.range = range
        self.stepCount = stepCount
        self.curved = curved
        self.axis = axis
    }
    
    private var horizontalSlider: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: geometry.size.width * 0.44, height: 16)
                        
                        HStack(spacing: 0) {
                            ForEach(0..<stepCount+1) { index in
                                let isFifth = index % 5 == 0
                                Rectangle()
                                    .fill(.primary.opacity(isFifth ? 1 : 0.75))
                                    .frame(width: 1, height: isFifth ? 16 : 12)
                                    .frame(width: geometry.size.width / 19)
                                    .conditional(curved) { body in
                                        body
                                            .scaleEffect(y: 1 - (CGFloat(abs(index - (scrollPosition ?? Int((value - range.lowerBound) / step)))) / (geometry.size.width / 24)).clamped(to: 0...1))
                                            .opacity(1 - (Double(abs(index - (scrollPosition ?? Int((value - range.lowerBound) / step)))) / (geometry.size.width / 23)).clamped(to: 0...1))
                                    }
                                    .conditional(!curved) { body in
                                        body
                                            .scrollTransition(.animated(.easeOut(duration: 0.25)).threshold(.visible)) { content, phase in
                                                content
                                                    .scaleEffect(phase.isIdentity ? 1 : 0.5)
                                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                            }
                                    }
                                    .id(index)
                            } // ForEach
                        } // HStack
                        .scrollTargetLayout()
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: geometry.size.width * 0.44, height: 16)
                    } // HStack
                    .padding(.vertical, 4)
                    .contentShape(.rect)
                } // ScrollView
                .scrollIndicators(.never)
                .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
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
                .frame(width: 2.5, height: 22)
        }
        .frame(height: 34)
    }
    
    private var verticalSlider: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 16, height: geometry.size.height * 0.45)
                        
                        VStack(spacing: 0) {
                            ForEach(0..<stepCount+1) { index in
                                let isFifth = index % 5 == 0
                                Rectangle()
                                    .fill(.primary.opacity(isFifth ? 1 : 0.5))
                                    .frame(width: isFifth ? 16 : 12, height: 1)
                                    .frame(height: geometry.size.height / 18.66)
                                    .conditional(curved) { body in
                                        body
                                            .scaleEffect(x: 1 - (CGFloat(abs(index - (scrollPosition ?? Int((value - range.lowerBound) / step)))) / (geometry.size.height / 24)).clamped(to: 0...1))
                                            .opacity(1 - (Double(abs(index - (scrollPosition ?? Int((value - range.lowerBound) / step)))) / (geometry.size.height / 23)).clamped(to: 0...1))
                                    }
                                    .conditional(!curved) { body in
                                        body
                                            .scrollTransition(.animated(.easeOut(duration: 0.25)).threshold(.visible)) { content, phase in
                                                content
                                                    .scaleEffect(phase.isIdentity ? 1 : 0.5)
                                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                            }
                                    }
                                    .id(index)
                            } // ForEach
                        } // VStack
                        .scrollTargetLayout()
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 16, height: geometry.size.height * 0.44)
                    } // VStack
                    .padding(.horizontal, 4)
                    .contentShape(.rect)
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
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(.yellow)
                .frame(width: 22, height: 2.5)
                .offset(y: 2)
        }
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
