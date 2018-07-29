import Foundation

class Implementation:CodableHero {
    let dispatch:DispatchQueue
    
    init() {
        self.dispatch = DispatchQueue(label:Constants.identifier, qos:DispatchQoS.background,
                                      attributes:DispatchQueue.Attributes.concurrent,
                                      autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                      target:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
    }
    
    func load<Model:Codable>(path:String, onCompletion:((Model) -> Void)?, onError:((Error) -> Void)?) {
        
    }
    
    func load<Model:Codable>(pathInBundle:String, onCompletion:((Model) -> Void)?, onError:((Error) -> Void)?) {
        
    }
    
    func save<Model:Codable>(model:Model, path:String, onCompletion:(() -> Void)?, onError:((Error) -> Void)?) {
        
    }
    
    func delete(path:String, onCompletion:(() -> Void)?, onError:((Error) -> Void)?) {
        
    }
}

private struct Constants {
    static let identifier:String = "iturbide.codablehero"
}
