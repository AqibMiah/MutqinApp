import SwiftUI

extension Font {
    static func sfProText(_ size: CGFloat) -> Font {
        return .system(size: size, weight: .regular)
    }
    
    static func sfProTextMedium(_ size: CGFloat) -> Font {
        return .system(size: size, weight: .medium)
    }
    
    static func sfProTextSemibold(_ size: CGFloat) -> Font {
        return .system(size: size, weight: .semibold)
    }
    
    static func sfProTextBold(_ size: CGFloat) -> Font {
        return .system(size: size, weight: .bold)
    }
} 