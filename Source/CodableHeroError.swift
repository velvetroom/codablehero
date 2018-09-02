import Foundation

public enum CodableHeroError:LocalizedError {
    case fileNotFound
    case invalidPath
    
    public var errorDescription:String? { return String(describing:self) }
}
