//
//  Constants.swift
//  TouchingMyBar
//
//  Created by Dominik Bucher on 02/04/2020.
//  Copyright © 2020 Dominik Bucher. All rights reserved.
//

import Foundation
import IOKit

public enum Constants {
    public enum TouchBar {
        /// The height of touchbar. Until Apple gets crazy, this never needs to be more than 30 points.
        public static let height: CGFloat = 30
        
        /// The Width of touchbar. On Newer 16" Model it's actually 1004px. On Older it's 1085px.
        ///
        /// To clarify and quote Apple developer documentation:
        /// `There is no API for you to obtain the current available display width.`
        public static var width: CGFloat {
            let supportedModel = TouchBarSupportingMacs(rawValue: Constants.TouchBar.getMacModel())
            guard let model = supportedModel else { fatalError("Macbook not supporting touchbar 🤯") }

            return model == .sixteenInch2019NormalKeyboard ? 1004 : 1085
        }

        /// This is really funny way to figure out the Touchbar width :D But here we go :D
        /// - Returns: The current mac model with Macbook13,2 or whatever :D
        private static func getMacModel() -> String {
            let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))

            guard let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data,
                  let modelIdentifierCString = String(data: modelData, encoding: .utf8)?.cString(using: .utf8)
            else { return "Unknown mac model?"}

            defer { IOObjectRelease(service) } // See documentation on the method why I need to do this.
            return String(cString: modelIdentifierCString)
        }
    }
    
    public enum BarElementWidth: CGFloat {
        case small = 60
        case big = 120
    }
    
    public enum AppIDs {
        public static let xcode = "com.apple.dt.Xcode"
        public static let xTouchBar = "com.dominikbucher.TouchingMyBar"
    }
}


private enum TouchBarSupportingMacs: String, CaseIterable {
    case thirteenInch2016 = "MacBookPro13,2"
    case thirteenInch2017 = "MacBookPro14,2"
    case thirteenInch2018 = "MacBookPro15,2"
    case thirteenInch2019 = "MacBookPro15,4"
    case fifteenInch2016 = "MacBookPro13,3"
    case fifteenInch2017 = "MacBookPro14,3"
    case fifteenInch2018 = "MacBookPro15,1" // Really consistent Apple.
    case fifteenInch2018VEGA = "MacBookPro15,3"
    case sixteenInch2019NormalKeyboard = "MacBookPro16,1"
}
