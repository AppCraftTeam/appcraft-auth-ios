import XCTest
@testable import ACAuth

final class PhoneFormatterTests: XCTestCase {
    
    private var original = ""
    
    @PhoneFormatter
    private var formatted = ""
    
    func test_inject_valid_number() {
        
        self.original = "79328341932"
        self.formatted = original
        
        XCTAssert(original == formatted, "\(original) == \(formatted)")
    }
    
    func test_inject_invalid_number() {
        
        self.original = "+7(932)8341932"
        self.formatted = original
        XCTAssert(formatted == "79328341932", "\(formatted) == 79328341932")

        self.original = "+7(932)834-19-32"
        self.formatted = original
        XCTAssert(original != formatted, "\(original) != \(formatted)")
        XCTAssert(formatted == "79328341932", "\(formatted) == 79328341932")
    }
}
