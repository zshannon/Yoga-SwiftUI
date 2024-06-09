//
//  File.swift
//
//
//  Created by Peter Vu on 11/06/2023.
//

import SwiftUI
import Yoga

public struct Flex<V: View>: View {
    @Environment(\.layoutDirection)
    var layoutDirection
    
    public var direction: YGFlexDirection = .row
    public var justifyContent: YGJustify = .flexStart
    public var alignItems: YGAlign = .flexStart
    public var alignContent: YGAlign = .flexStart
    public var wrap: YGWrap = .noWrap
    public var rowGap: CGFloat = 0
    public var columnGap: CGFloat = 0
    
    private var contentBuilder: () -> V
    
    public init(direction: YGFlexDirection = .row,
                justifyContent: YGJustify = .flexStart,
                alignItems: YGAlign = .flexStart,
                alignContent: YGAlign = .flexStart,
                wrap: YGWrap = .noWrap,
                rowGap: CGFloat = 0,
                columnGap: CGFloat = 0,
                @ViewBuilder contentBuilder: @escaping () -> V) {
        self.direction = direction
        self.justifyContent = justifyContent
        self.alignItems = alignItems
        self.alignContent = alignContent
        self.wrap = wrap
        self.rowGap = rowGap
        self.columnGap = columnGap
        self.contentBuilder = contentBuilder
    }
    
    public var body: some View {
        _Flex(direction: direction,
              justifyContent: justifyContent,
              alignItems: alignItems,
              alignContent: alignContent,
              wrap: wrap, rowGap: rowGap,
              columnGap: columnGap,
              layoutDirection: ygLayoutDirection) {
            contentBuilder()
        }
    }
    
    private var ygLayoutDirection: YGDirection {
        switch layoutDirection {
        case .leftToRight:
            return .LTR
        case .rightToLeft:
            return .RTL
        @unknown default:
            return .LTR
        }
    }
}

struct _Flex: SwiftUI.Layout {
    public var direction: YGFlexDirection = .row
    public var justifyContent: YGJustify = .flexStart
    public var alignItems: YGAlign = .flexStart
    public var alignContent: YGAlign = .flexStart
    public var wrap: YGWrap = .noWrap
    public var rowGap: CGFloat = 0
    public var columnGap: CGFloat = 0
    public var layoutDirection: YGDirection = .LTR
    public typealias Cache = YGNodeRef
    
    public init(direction: YGFlexDirection,
                justifyContent: YGJustify,
                alignItems: YGAlign,
                alignContent: YGAlign,
                wrap: YGWrap,
                rowGap: CGFloat,
                columnGap: CGFloat,
                layoutDirection: YGDirection) {
        self.direction = direction
        self.justifyContent = justifyContent
        self.alignItems = alignItems
        self.alignContent = alignContent
        self.wrap = wrap
        self.rowGap = rowGap
        self.columnGap = columnGap
        self.layoutDirection = layoutDirection
    }

    public func makeCache(subviews _: Subviews) -> YGNodeRef {
        let config = createConfig()
        let root = createRoot(withConfig: config)
        return root
    }

    public func sizeThatFits(proposal: ProposedViewSize,
                             subviews: Subviews,
                             cache: inout YGNodeRef) -> CGSize {
        let root = cache
        YGNodeRemoveAllChildren(root)
        setRootDimensions(root: root, proposal: proposal)
        setupNodes(subviews: subviews, root: root)
        
        YGNodeCalculateLayout(cache, Float.nan, Float.nan, layoutDirection)

        return CGSize(width: CGFloat(YGNodeLayoutGetWidth(root)),
                      height: CGFloat(YGNodeLayoutGetHeight(root)))
    }

    public func placeSubviews(in bounds: CGRect,
                              proposal _: ProposedViewSize,
                              subviews: Subviews,
                              cache: inout YGNodeRef) {
        setSubviewsPosition(in: bounds, subviews: subviews, cache: &cache)
    }
    
    private func createConfig() -> YGConfigRef {
        let config = YGConfigNew()
        YGConfigSetUseWebDefaults(config, true)
        YGConfigSetExperimentalFeatureEnabled(config, .webFlexBasis, true)
        YGConfigSetErrata(config, .all)
        return config!
    }
    
    private func createRoot(withConfig config: YGConfigRef) -> YGNodeRef {
        let root = YGNodeNewWithConfig(config)
        YGNodeStyleSetFlex(root, 1)
        YGNodeStyleSetFlexDirection(root, direction)
        YGNodeStyleSetJustifyContent(root, justifyContent)
        YGNodeStyleSetWidthAuto(root)
        YGNodeStyleSetHeightAuto(root)
        YGNodeStyleSetFlexWrap(root, wrap)
        YGNodeStyleSetGap(root, YGGutter.row, Float(rowGap))
        YGNodeStyleSetGap(root, YGGutter.column, Float(columnGap))
        YGNodeStyleSetAlignItems(root, alignItems)
        YGNodeStyleSetAlignContent(root, alignContent)
        return root!
    }
    
    private func setRootDimensions(root: YGNodeRef, proposal: ProposedViewSize) {
        if let width = proposal.width {
            YGNodeStyleSetWidth(root, Float(width))
        }

        if let height = proposal.height {
            YGNodeStyleSetHeight(root, Float(height))
        }
    }
    
    private func setupNodes(subviews: Subviews, root: YGNodeRef) {
        for (idx, subview) in subviews.enumerated() {
            let subnode = createSubnode(forSubview: subview)
            YGNodeInsertChild(root, subnode, UInt32(idx))
        }
    }
    
    private func createSubnode(forSubview subview: LayoutSubviews.Element) -> YGNodeRef {
        let subnode = YGNodeNew()!
        let size = subview.sizeThatFits(.unspecified)
        let flexGrow = subview[FlexGrowLayoutValueKey.self]
        let flexShrink = subview[FlexShrinkLayoutValueKey.self]
        let alignSelf = subview[AlignSelfLayoutValueKey.self]
        let flexBasis = subview[FlexBasisLayoutValueKey.self]
        let minWidth = subview[MinWidthLayoutValueKey.self]
        let maxWidth = subview[MaxWidthLayoutValueKey.self]
        let width = subview[WidthLayoutValueKey.self]
        let minHeight = subview[MinHeightLayoutValueKey.self]
        let maxHeight = subview[MaxHeightLayoutValueKey.self]
        let height = subview[HeightLayoutValueKey.self]

        // Setting flex properties
        YGNodeStyleSetFlexGrow(subnode, Float(flexGrow))
        YGNodeStyleSetFlexShrink(subnode, Float(flexShrink))
        YGNodeStyleSetAlignSelf(subnode, alignSelf)

        // Setting flexBasis
        switch flexBasis.unit {
        case .auto:
            YGNodeStyleSetFlexBasisAuto(subnode)
        case .percent:
            YGNodeStyleSetFlexBasisPercent(subnode, flexBasis.value)
        case .point:
            YGNodeStyleSetFlexBasis(subnode, flexBasis.value)
        case .undefined:
            break
        @unknown default:
            break
        }
        
        // Setting dimensions
        setDimension(subnode: subnode, dimension: width, size: size.width, isWidth: true)
        setDimension(subnode: subnode, dimension: height, size: size.height, isWidth: false)

        // Setting min/max dimensions
        setMinMaxDimension(subnode: subnode, value: minWidth, isMin: true, isWidth: true)
        setMinMaxDimension(subnode: subnode, value: maxWidth, isMin: false, isWidth: true)
        setMinMaxDimension(subnode: subnode, value: minHeight, isMin: true, isWidth: false)
        setMinMaxDimension(subnode: subnode, value: maxHeight, isMin: false, isWidth: false)

        // Setting additional properties
        setAdditionalProperties(subview: subview, subnode: subnode)


        return subnode
    }
    
    private func setSubviewsPosition(in bounds: CGRect,
                                     subviews: Subviews,
                                     cache: inout YGNodeRef) {
        for (idx, subview) in subviews.enumerated() {
            if let subnode = YGNodeGetChild(cache, UInt32(idx)) {
                let y = YGNodeLayoutGetTop(subnode)
                let x = YGNodeLayoutGetLeft(subnode)
                let width = YGNodeLayoutGetWidth(subnode)
                let height = YGNodeLayoutGetHeight(subnode)
                subview.place(at: CGPoint(x: bounds.minX + CGFloat(x),
                                          y: bounds.minY + CGFloat(y)),
                              proposal: .init(CGSize(width: CGFloat(width),
                                                     height: CGFloat(height))))
            }
        }
    }

private func setDimension(subnode: YGNodeRef, dimension: YogaDimension, size: CGFloat, isWidth: Bool) {
  switch dimension {
  case .auto:
    if isWidth {
      YGNodeStyleSetMinWidth(subnode, Float(ceil(size)))
    } else {
      YGNodeStyleSetMinHeight(subnode, Float(ceil(size)))
    }
  case let .percent(value):
    if isWidth {
      YGNodeStyleSetWidthPercent(subnode, value)
    } else {
      YGNodeStyleSetHeightPercent(subnode, value)
    }
  case let .point(value):
    if isWidth {
      YGNodeStyleSetWidth(subnode, value)
    } else {
      YGNodeStyleSetHeight(subnode, value)
    }
  }
}

private func setMinMaxDimension(
  subnode: YGNodeRef, value: YogaDimension, isMin: Bool, isWidth: Bool
) {
  switch value {
  case .auto:
    break
  case let .percent(pct):
    if isMin {
      if isWidth {
        YGNodeStyleSetMinWidthPercent(subnode, pct)
      } else {
        YGNodeStyleSetMinHeightPercent(subnode, pct)
      }
    } else {
      if isWidth {
        YGNodeStyleSetMaxWidthPercent(subnode, pct)
      } else {
        YGNodeStyleSetMaxHeightPercent(subnode, pct)
      }
    }
  case let .point(pt):
    if isMin {
      if isWidth {
        YGNodeStyleSetMinWidth(subnode, pt)
      } else {
        YGNodeStyleSetMinHeight(subnode, pt)
      }
    } else {
      if isWidth {
        YGNodeStyleSetMaxWidth(subnode, pt)
      } else {
        YGNodeStyleSetMaxHeight(subnode, pt)
      }
    }
  }
}

private func setAdditionalProperties(subview: LayoutSubviews.Element, subnode: YGNodeRef) {
  let position = subview[PositionLayoutValueKey.self]
  let marginTop = subview[MarginTopLayoutValueKey.self]
  let marginRight = subview[MarginRightLayoutValueKey.self]
  let marginBottom = subview[MarginBottomLayoutValueKey.self]
  let marginLeft = subview[MarginLeftLayoutValueKey.self]
  let paddingTop = subview[PaddingTopLayoutValueKey.self]
  let paddingRight = subview[PaddingRightLayoutValueKey.self]
  let paddingBottom = subview[PaddingBottomLayoutValueKey.self]
  let paddingLeft = subview[PaddingLeftLayoutValueKey.self]
  let borderWidth = subview[BorderWidthLayoutValueKey.self]

  YGNodeStyleSetPositionType(subnode, position)

  setEdgeProperty(subnode: subnode, edge: .top, value: marginTop, isPadding: false)
  setEdgeProperty(subnode: subnode, edge: .right, value: marginRight, isPadding: false)
  setEdgeProperty(subnode: subnode, edge: .bottom, value: marginBottom, isPadding: false)
  setEdgeProperty(subnode: subnode, edge: .left, value: marginLeft, isPadding: false)

  setEdgeProperty(subnode: subnode, edge: .top, value: paddingTop, isPadding: true)
  setEdgeProperty(subnode: subnode, edge: .right, value: paddingRight, isPadding: true)
  setEdgeProperty(subnode: subnode, edge: .bottom, value: paddingBottom, isPadding: true)
  setEdgeProperty(subnode: subnode, edge: .left, value: paddingLeft, isPadding: true)

  YGNodeStyleSetBorder(subnode, .all, Float(borderWidth))
}

private func setEdgeProperty(subnode: YGNodeRef, edge: YGEdge, value: YGValue, isPadding: Bool) {
  switch value.unit {
  case .auto:
    break
  case .percent:
    if isPadding {
      YGNodeStyleSetPaddingPercent(subnode, edge, value.value)
    } else {
      YGNodeStyleSetMarginPercent(subnode, edge, value.value)
    }
  case .point:
    if isPadding {
      YGNodeStyleSetPadding(subnode, edge, value.value)
    } else {
      YGNodeStyleSetMargin(subnode, edge, value.value)
    }
  case .undefined:
    break
  @unknown default:
    break
  }
}

}
