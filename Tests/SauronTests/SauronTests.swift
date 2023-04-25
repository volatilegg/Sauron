import XCTest
@testable import Sauron

final class SauronTests: XCTestCase {
    func testDefaultMode() throws {
        // Default mode shall always disable
        XCTAssertEqual(Sauron().logMode, .disable)
    }
}
