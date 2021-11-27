//
//  SliderValue.swift
//  TodoAppSwiftUI
//
//  Created by ISHAN LADANI on 27/11/21.
//

import Foundation
import SwiftUI

// make your observable double for the slider value:
class SliderValue: ObservableObject {
    @Published var position: Double = 0.0
}
