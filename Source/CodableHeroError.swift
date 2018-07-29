import Foundation

public struct CodableHeroError:LocalizedError {
    public let errorDescription:String?
    
    static let fileNotFound:CodableHeroError = CodableHeroError(errorDescription:NSLocalizedString(
        "fileNotFound", tableName:nil, bundle:Bundle(for:Implementation.self), comment:String()))
}
