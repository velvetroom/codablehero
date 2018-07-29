import Foundation

public protocol CodableHero {
    func load<Model:Decodable>(path:String, completion:((Model) -> Void)?, error:((Error) -> Void)?)
    func load<Model:Decodable>(bundle:Bundle, path:String, completion:((Model) -> Void)?, error:((Error) -> Void)?)
    func save<Model:Encodable>(model:Model, path:String, completion:(() -> Void)?, error:((Error) -> Void)?)
    func delete(path:String, completion:(() -> Void)?, error:((Error) -> Void)?)
}
