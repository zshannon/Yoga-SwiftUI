//
//  File.swift
//  
//
//  Created by Peter Vu on 11/06/2023.
//

import Yoga
import SwiftUI

public struct JustifyContentLayoutValueKey: LayoutValueKey {
    public typealias Value = YGJustify
    public static var defaultValue: Value = .flexStart
}

public extension View {
    func justifyContent(_ value: YGJustify) -> some View {
        return layoutValue(key: JustifyContentLayoutValueKey.self, value: value)
    }

    func alignItems(_ value: YGAlign) -> some View {
        return layoutValue(key: AlignItemLayoutValueKey.self, value: value)
    }

    func alignSelf(_ value: YGAlign) -> some View {
        return layoutValue(key: AlignSelfLayoutValueKey.self, value: value)
    }

    func flexDirection(_ value: YGFlexDirection) -> some View {
        return layoutValue(key: FlexDirectionLayoutValueKey.self, value: value)
    }

    func flexWrap(_ value: YGWrap) -> some View {
        return layoutValue(key: FlexWrapLayoutValueKey.self, value: value)
    }

    func flexBasis(_ value: YGValue) -> some View {
        return layoutValue(key: FlexBasisLayoutValueKey.self, value: value)
    }

    func flexGrow(_ value: CGFloat) -> some View {
        return layoutValue(key: FlexGrowLayoutValueKey.self, value: value)
    }

    func flexShrink(_ value: CGFloat) -> some View {
        return layoutValue(key: FlexShrinkLayoutValueKey.self, value: value)
    }
    
    func width(_ dimension: YogaDimension) -> some View {
        return layoutValue(key: WidthLayoutValueKey.self, value: dimension)
    }
    
    func maxWidth(_ dimension: YogaDimension) -> some View {
        return layoutValue(key: MaxWidthLayoutValueKey.self, value: dimension)
    }
    
    func minWidth(_ dimension: YogaDimension) -> some View {
        return layoutValue(key: MinWidthLayoutValueKey.self, value: dimension)
    }
    
    func height(_ dimension: YogaDimension) -> some View {
        return layoutValue(key: HeightLayoutValueKey.self, value: dimension)
    }
    
    func maxHeight(_ dimension: YogaDimension) -> some View {
        return layoutValue(key: MaxHeightLayoutValueKey.self, value: dimension)
    }
    
    func minHeight(_ dimension: YogaDimension) -> some View {
        return layoutValue(key: MinHeightLayoutValueKey.self, value: dimension)
    }

    
    func position(_ value: YGPositionType) -> some View {
        return layoutValue(key: PositionLayoutValueKey.self, value: value)
    }

    func marginTop(_ value: YGValue) -> some View {
        return layoutValue(key: MarginTopLayoutValueKey.self, value: value)
    }

    func marginRight(_ value: YGValue) -> some View {
        return layoutValue(key: MarginRightLayoutValueKey.self, value: value)
    }

    func marginBottom(_ value: YGValue) -> some View {
        return layoutValue(key: MarginBottomLayoutValueKey.self, value: value)
    }

    func marginLeft(_ value: YGValue) -> some View {
        return layoutValue(key: MarginLeftLayoutValueKey.self, value: value)
    }

    func paddingTop(_ value: YGValue) -> some View {
        return layoutValue(key: PaddingTopLayoutValueKey.self, value: value)
    }

    func paddingRight(_ value: YGValue) -> some View {
        return layoutValue(key: PaddingRightLayoutValueKey.self, value: value)
    }

    func paddingBottom(_ value: YGValue) -> some View {
        return layoutValue(key: PaddingBottomLayoutValueKey.self, value: value)
    }

    func paddingLeft(_ value: YGValue) -> some View {
        return layoutValue(key: PaddingLeftLayoutValueKey.self, value: value)
    }

    func borderWidth(_ value: CGFloat) -> some View {
        return layoutValue(key: BorderWidthLayoutValueKey.self, value: value)
    }
}

public struct AlignContentLayoutValueKey: LayoutValueKey {
    public typealias Value = YGAlign
    public static var defaultValue: Value = .flexStart
}

public struct AlignItemLayoutValueKey: LayoutValueKey {
    public typealias Value = YGAlign
    public static var defaultValue: Value = .stretch
}

public struct AlignSelfLayoutValueKey: LayoutValueKey {
    public typealias Value = YGAlign
    public static var defaultValue: Value = .auto
}

public struct FlexDirectionLayoutValueKey: LayoutValueKey {
    public typealias Value = YGFlexDirection
    public static var defaultValue: YGFlexDirection = .row
}

public struct FlexWrapLayoutValueKey: LayoutValueKey {
    public typealias Value = YGWrap
    public static var defaultValue: YGWrap = .noWrap
}

public struct FlexBasisLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 1, unit: .auto)
}

public struct FlexGrowLayoutValueKey: LayoutValueKey {
    public typealias Value = CGFloat
    public static var defaultValue: CGFloat = 0
}

public struct FlexShrinkLayoutValueKey: LayoutValueKey {
    public typealias Value = CGFloat
    public static var defaultValue: CGFloat = 1
}

public struct WidthLayoutValueKey: LayoutValueKey {
    public typealias Value = YogaDimension
    public static var defaultValue: YogaDimension = .auto
}

public struct MaxWidthLayoutValueKey: LayoutValueKey {
    public typealias Value = YogaDimension
    public static var defaultValue: YogaDimension = .auto
}

public struct MinWidthLayoutValueKey: LayoutValueKey {
    public typealias Value = YogaDimension
    public static var defaultValue: YogaDimension = .auto
}

public struct HeightLayoutValueKey: LayoutValueKey {
    public typealias Value = YogaDimension
    public static var defaultValue: YogaDimension = .auto
}

public struct MaxHeightLayoutValueKey: LayoutValueKey {
    public typealias Value = YogaDimension
    public static var defaultValue: YogaDimension = .auto
}

public struct MinHeightLayoutValueKey: LayoutValueKey {
    public typealias Value = YogaDimension
    public static var defaultValue: YogaDimension = .auto
}

public struct PositionLayoutValueKey: LayoutValueKey {
    public typealias Value = YGPositionType
    public static var defaultValue: Value = .relative
}

public struct MarginTopLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct MarginRightLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct MarginBottomLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct MarginLeftLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PaddingTopLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PaddingRightLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PaddingBottomLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PaddingLeftLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct BorderWidthLayoutValueKey: LayoutValueKey {
    public typealias Value = CGFloat
    public static var defaultValue: CGFloat = 0
}

public enum YogaDimension {
    case auto
    case percent(Float) // 0...1
    case point(Float)
}
