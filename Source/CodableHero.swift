import Foundation

public protocol CodableHero {
    func load<Model:Codable>(path:String, onCompletion:((Model) -> Void)?, onError:((Error) -> Void)?)
    func load<Model:Codable>(pathInBundle:String, onCompletion:((Model) -> Void)?, onError:((Error) -> Void)?)
    func save<Model:Codable>(model:Model, path:String, onCompletion:(() -> Void)?, onError:((Error) -> Void)?)
    func delete(path:String, onCompletion:(() -> Void)?, onError:((Error) -> Void)?)
}
