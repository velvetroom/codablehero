import Foundation

public class Factory {
    public class func makeCodableHero() -> CodableHero {
        return Implementation()
    }
    
    private init() { }
}
