import XCTest
@testable import CodableHero

class TestImplementation:XCTestCase {
    private var implementation:Implementation!
    private var path:URL!
    private struct Constants {
        static let fileName:String = "test.asd"
    }
    
    override func setUp() {
        super.setUp()
        let directory:URL = FileManager.default.urls(for:FileManager.SearchPathDirectory.documentDirectory,
                                                     in:FileManager.SearchPathDomainMask.userDomainMask).last!
        self.path = directory.appendingPathComponent(Constants.fileName)
        self.implementation = Implementation()
    }
    
    override func tearDown() {
        super.tearDown()
        do { try FileManager.default.removeItem(at:self.path) } catch { }
    }
    
    func testErrorIfInvalidPath() {
        let expect:XCTestExpectation = self.expectation(description:"Not throwing")
        self.implementation.load(bundle:Bundle.main, path:"a b", completion: { (_:Int) in }, error: { (error:Error) in
            let error:CodableHeroError = error as! CodableHeroError
            XCTAssertEqual(error.code, CodableHeroError.invalidPath.code, "Invalid error type")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            expect.fulfill()
        })
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadBundleSuccess() {
        let expect:XCTestExpectation = self.expectation(description:"Not loading")
        self.implementation.load(bundle:Bundle(for:TestImplementation.self), path:"MockFile.json",
                                 completion: { (model:MockModel) in
                                    XCTAssertEqual(model.title, "hello world")
                                    XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
                                    expect.fulfill()
        }, error:nil)
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testLoadError() {
        let expect:XCTestExpectation = self.expectation(description:"Not throwing")
        self.implementation.load(path:"MockFile.json", completion: { (_:Int) in }, error: { (error:Error) in
            let error:CodableHeroError = error as! CodableHeroError
            XCTAssertEqual(error.code, CodableHeroError.fileNotFound.code, "Invalid error type")
            XCTAssertEqual(Thread.current, Thread.main, "Not main thread")
            expect.fulfill()
        })
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
}
