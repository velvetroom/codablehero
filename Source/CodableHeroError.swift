import Foundation

public struct CodableHeroError:LocalizedError {
    public let errorDescription:String?
    public let code:Int
    
    static let fileNotFound:CodableHeroError = CodableHeroError(errorDescription:NSLocalizedString(
        "fileNotFound", tableName:nil, bundle:Bundle(for:Implementation.self), comment:String()), code:1)
    static let invalidPath:CodableHeroError = CodableHeroError(errorDescription:NSLocalizedString(
        "invalidPath", tableName:nil, bundle:Bundle(for:Implementation.self), comment:String()), code:2)
}
