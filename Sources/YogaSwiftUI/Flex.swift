//
//  File.swift
//
//
//  Created by Peter Vu on 11/06/2023.
//

import SwiftUI
import yoga

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

  public init(
    direction: YGFlexDirection = .row,
    justifyContent: YGJustify = .flexStart,
    alignItems: YGAlign = .flexStart,
    alignContent: YGAlign = .flexStart,
    wrap: YGWrap = .noWrap,
    rowGap: CGFloat = 0,
    columnGap: CGFloat = 0,
    @ViewBuilder contentBuilder: @escaping () -> V
  ) {
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
    FlexLayout(
      direction: direction,
      justifyContent: justifyContent,
      alignItems: alignItems,
      alignContent: alignContent,
      wrap: wrap, rowGap: rowGap,
      columnGap: columnGap,
      layoutDirection: ygLayoutDirection
    ) {
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
