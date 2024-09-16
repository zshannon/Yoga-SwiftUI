//
//  File.swift
//
//
//  Created by Peter Vu on 11/06/2023.
//

import SwiftUI
import Yoga

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

    func positionTop(_ value: YGValue) -> some View {
        return layoutValue(key: PositionTopLayoutValueKey.self, value: value)
    }

    func positionLeft(_ value: YGValue) -> some View {
        return layoutValue(key: PositionLeftLayoutValueKey.self, value: value)
    }

    func positionRight(_ value: YGValue) -> some View {
        return layoutValue(key: PositionRightLayoutValueKey.self, value: value)
    }

    func positionBottom(_ value: YGValue) -> some View {
        return layoutValue(key: PositionBottomLayoutValueKey.self, value: value)
    }

    func positionEnd(_ value: YGValue) -> some View {
        return layoutValue(key: PositionEndLayoutValueKey.self, value: value)
    }

    func positionStart(_ value: YGValue) -> some View {
        return layoutValue(key: PositionStartLayoutValueKey.self, value: value)
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

    func marginStart(_ value: YGValue) -> some View {
        return layoutValue(key: MarginStartLayoutValueKey.self, value: value)
    }

    func marginEnd(_ value: YGValue) -> some View {
        return layoutValue(key: MarginEndLayoutValueKey.self, value: value)
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

    func paddingStart(_ value: YGValue) -> some View {
        return layoutValue(key: PaddingStartLayoutValueKey.self, value: value)
    }

    func paddingEnd(_ value: YGValue) -> some View {
        return layoutValue(key: PaddingEndLayoutValueKey.self, value: value)
    }

    func borderWidth(_ value: CGFloat) -> some View {
        return layoutValue(key: BorderWidthLayoutValueKey.self, value: value)
    }

    func display(_ value: YGDisplay) -> some View {
        return layoutValue(key: DisplayLayoutValueKey.self, value: value)
    }

    /**
     Used to inspect the views layout metics. Useful for debugging and creating UI tests
     See ``FlexLayoutInspector/getLayoutMetricsFor(flexSubViewID:)`` on how to get a view's metrics based on its
     introspection key ID. Set with ``flexIntrospectionKey()`` view modifier.
     NOTE: Only works if the view is contained by the ``Flex`` layout.
     */
    func flexIntrospectionKey(_ key: String) -> some View {
        layoutValue(key: FlexLayoutMetricsIntrospectionKey.self, value: key)
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

public struct MarginStartLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct MarginEndLayoutValueKey: LayoutValueKey {
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

public struct PaddingStartLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PaddingEndLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PositionTopLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PositionRightLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PositionBottomLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PositionLeftLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PositionStartLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct PositionEndLayoutValueKey: LayoutValueKey {
    public typealias Value = YGValue
    public static var defaultValue: YGValue = .init(value: 0, unit: .point)
}

public struct BorderWidthLayoutValueKey: LayoutValueKey {
    public typealias Value = CGFloat
    public static var defaultValue: CGFloat = 0
}

public struct DisplayLayoutValueKey: LayoutValueKey {
    public typealias Value = YGDisplay
    public static var defaultValue: YGDisplay = .flex
}

/// Used to inspect the views layout metics.
/// See ``FlexLayoutInspector/getLayoutMetricsFor(flexSubViewID:)`` on how to get a view's metrics based on its
/// introspection key ID. Set with ``flexIntrospectionKey()`` view modifier
public struct FlexLayoutMetricsIntrospectionKey: LayoutValueKey {
    public static var defaultValue: String?
}

public enum YogaDimension: Equatable {
    case auto
    case percent(Float) // 0...1
    case point(Float)
}
