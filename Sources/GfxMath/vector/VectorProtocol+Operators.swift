extension VectorProtocol {
  @inlinable public func dot(_ otherVector: Self) -> Element {
    var result = Element.zero
    for i in 0..<count {
      result += self[i] * otherVector[i]
    }
    return result
  }

  /*@inlinable public static func += (lhs: inout Self, rhs: Self) {
    for i in 0..<lhs.rows {
      lhs[i] += rhs[i]
    }
  }*/

  /*@inlinable public static func + (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result += rhs
    return result 
  }*/

  @inlinable public static func += <O: VectorProtocol>(lhs: inout Self, rhs: O) where O.Dimension == Dimension, O.Element == Element {
    for i in 0..<lhs.rows {
      lhs[i] += rhs[i]
    }
  }

  @inlinable public static func + <O: VectorProtocol>(lhs: Self, rhs: O) -> Self where O.Dimension == Dimension, O.Element == Element {
    var result = lhs
    result += rhs
    return result
  }

  /*@inlinable public static func -= (lhs: inout Self, rhs: Self) {
    for i in 0..<Swift.min(lhs.rows, rhs.rows) {
      lhs[i] -= rhs[i]
    }
  }

  @inlinable public static func - (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result -= rhs
    return result
  }*/

  @inlinable public static func -= <O: VectorProtocol>(lhs: inout Self, rhs: O) where O.Dimension == Dimension, O.Element == Element {
    for i in 0..<lhs.rows {
      lhs[i] -= rhs[i]
    }
  }

  @inlinable public static func - <O: VectorProtocol>(lhs: Self, rhs: O) -> Self where O.Dimension == Dimension, O.Element == Element {
    var result = lhs
    result -= rhs
    return result
  }

  @inlinable public static func *= (lhs: inout Self, rhs: Element) {
    for i in 0..<lhs.count {
      lhs[i] *= rhs
    }
  }

  @inlinable public static func *= (lhs: inout Self, rhs: Self) {
    for i in 0..<lhs.rows {
      lhs[i] *= rhs[i]
    }
  }

  @inlinable public static func * (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result *= rhs
    return result
  }
}

extension VectorProtocol where Element: Comparable {
  @inlinable public static func < (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 < rhs }
  }

  @inlinable public static func <= (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 <= rhs }
  }

  @inlinable public static func > (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 > rhs}
  }

  @inlinable public static func >= (lhs: Self, rhs: Element) -> Bool {
    lhs.elements.allSatisfy { $0 >= rhs }
  }

  @inlinable public static func < <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] < rhs[i]) {
        return false
      }
    }
    return true
  }

  @inlinable public static func <= <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] <= rhs[i]) {
        return false
      }
    }
    return true
  }

  @inlinable public static func > <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] > rhs[i]) {
        return false
      }
    }
    return true
  }

  @inlinable public static func >= <R: VectorProtocol>(lhs: Self, rhs: R) -> Bool where R.Element == Self.Element, R.Dimension == Self.Dimension {
    for i in 0..<lhs.rows {
      if !(lhs[i] >= rhs[i]) {
        return false
      }
    }
    return true
  }
}

extension VectorProtocol where Element: FloatingPoint {
  @inlinable public static func /= (lhs: inout Self, rhs: Element) {
   for i in 0..<lhs.count {
      lhs[i] = lhs[i] / rhs
    }
  }

  @inlinable public static func / (lhs: Self, rhs: Element) -> Self {
    var result = lhs
    result /= rhs
    return result
  }

  @inlinable public static func /= (lhs: inout Self, rhs: Self) {
    for i in 0..<lhs.count {
      lhs[i] /= rhs[i]
    }
  }

  @inlinable public static func / (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result /= rhs
    return result
  }
}

extension Vector3Protocol where Element: FloatingPointGenericMath {
  /// - Returns 0 to pi (positive only)
  @inlinable public func absAngle(to otherVector: Self) -> Element {
    let angle = acos(normalized().dot(otherVector.normalized()))
    return angle
  }

  /**
  internally constructs a quaternion to perform the rotation
  - Parameter angle: angle by which to rotate in degrees
  - Parameter axis: axis around which to rotate, will be normalized automatically
  */
  @inlinable public func rotated<V: Vector3Protocol>(by angle: Element, around axis: V) -> Self where V.Element == Element {
    let rotationQuat = Quaternion(angle: angle / 2, axis: axis)
    return rotated(by: rotationQuat)
  }
  
  @inlinable public func rotated(by quaternion: Quaternion<Element>) -> Self {
    let rotatedQuat = quaternion * Quaternion(w: 0, axis: self) * quaternion.inverse
    return Self(rotatedQuat.axis.elements)
  }
}

/// - Returns: The component-wise min of two given vectors.
@inlinable public func min<V: VectorProtocol>(_ vec1: V, _ vec2: V) -> V
where V.Element: Comparable {
  V.init((0..<vec1.count).map { vec1[$0] < vec2[$0] ? vec1[$0] : vec2[$0] })
}

/// - Returns: The component-wise max of two given vectors.
@inlinable public func max<V: VectorProtocol>(_ vec1: V, _ vec2: V) -> V
where V.Element: Comparable {
  V.init((0..<vec1.count).map { vec1[$0] > vec2[$0] ? vec1[$0] : vec2[$0] })
}