import UIKit

/// A read-only snapshot of one view's layout diagnostic state at the
/// moment it was captured. Plain data, safe to log or pass around freely —
/// it holds no reference back to the view itself.
public struct LayoutDiagnostic: Sendable {
    public let viewDescription: String
    public let isAmbiguous: Bool
    public let frame: CGRect
    public let affectingConstraintIdentifiers: [String]
}
