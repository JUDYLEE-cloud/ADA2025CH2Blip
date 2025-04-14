import Foundation
import SwiftUI

extension Font {
    enum Alexandria {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Alexandria-ExtraBold"
            case .bold:
                return "Alexandria-Bold"
            case .semibold:
                return "Alexandria-SemiBold"
            case .medium:
                return "Alexandria-Medium"
            case .regular:
                return "Alexandria-Regular"
            case .light:
                return "Alexandria-Light"
            }
        }
    }
    
    static func alexandria(type: Alexandria, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var AlexandriaBold30: Font {
        return .alexandria(type: .bold, size: 30)
    }
    
    /* 여기에 더 추가해주세요 */
    
}
