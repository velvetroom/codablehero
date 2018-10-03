import XCTest
@testable import CodableHero

class TestImplementation:XCTestCase {
    private var implementation:Hero!
    private var directory:URL!
    private var path:URL!
    
    override func setUp() {
        directory = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask).last!
        try? FileManager.default.createDirectory(at:directory, withIntermediateDirectories:true)
        path = directory.appendingPathComponent("test.asd")
        implementation = Hero()
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at:path)
    }
    
    func testErrorIfInvalidPath() {
        let expect = expectation(description:String())
        implementation.load(bundle:.main, path:"a b", completion: { (_:Int) in }, error: { error in
            let error = error as! HeroError
            XCTAssertEqual(HeroError.invalidPath, error)
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        })
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testLoadBundleSuccess() {
        let expect = expectation(description:String())
        implementation.load(bundle:Bundle(for:TestImplementation.self), path:"MockFile.json",
                            completion: { (model:MockModel) in
                                    XCTAssertEqual("hello world", model.title)
                                    XCTAssertEqual(Thread.main, Thread.current)
                                    expect.fulfill()
        }, error:nil)
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testLoadError() {
        let expect = expectation(description:String())
        implementation.load(path:"MockFile.json", completion: { (_:Int) in }, error: { error in
            let error = error as! HeroError
            XCTAssertEqual(HeroError.fileNotFound, error)
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        })
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testSaveSuccess() {
        let expect = expectation(description:String())
        self.implementation.save(model:MockModel(), path:"test.asd", completion: {
            XCTAssertEqual(Thread.main, Thread.current)
            XCTAssertTrue(FileManager.default.fileExists(atPath:self.path.path))
            expect.fulfill()
        }, error:nil)
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testSaveError() {
        let expect = expectation(description:String())
        try? FileManager.default.removeItem(at:directory)
        implementation.save(model:MockModel(), path:"test.asd", completion:nil, error: { error in
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        })
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testLoadSuccess() {
        let expect = expectation(description:String())
        var original = MockModel()
        original.title = "lorem ipsum"
        implementation.save(model:original, path:"test.asd", completion: {
            self.implementation.load(path:"test.asd", completion: { (model:MockModel) in
                XCTAssertEqual(original.title, model.title)
                XCTAssertEqual(Thread.main, Thread.current)
                expect.fulfill()
            }, error:nil)
        }, error:nil)
        waitForExpectations(timeout:1, handler:nil)
    }
}
