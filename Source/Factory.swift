import Foundation

public class Factory {
    class func makeCodableHero() -> CodableHero {
        return Implementation()
    }
    
    private init() { }
}
