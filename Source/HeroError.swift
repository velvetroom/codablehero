import Foundation

public enum HeroError:LocalizedError {
    case fileNotFound
    case invalidPath
    
    public var errorDescription:String? { return String(describing:self) }
}
