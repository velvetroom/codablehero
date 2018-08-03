import Foundation

public protocol CodableHero {
    func load<M:Decodable>(path:String, completion:((M) -> Void)?, error:((Error) -> Void)?)
    func load<M:Decodable>(bundle:Bundle, path:String, completion:((M) -> Void)?, error:((Error) -> Void)?)
    func save<M:Encodable>(model:M, path:String, completion:(() -> Void)?, error:((Error) -> Void)?)
    func delete(path:String, completion:(() -> Void)?, error:((Error) -> Void)?)
}
