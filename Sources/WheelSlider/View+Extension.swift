//
//  File.swift
//  WheelSlider
//
//  Created by Nozhan Amiri on 1/21/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func conditional(_ condition: Bool, body: @escaping (Self) -> some View) -> some View {
        if condition {
            body(self)
        } else {
            self
        }
    }
}
