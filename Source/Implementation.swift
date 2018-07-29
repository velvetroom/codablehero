import Foundation

class Implementation:CodableHero {
    let directory:URL
    let dispatch:DispatchQueue
    
    init() {
        self.directory = FileManager.default.urls(for:FileManager.SearchPathDirectory.documentDirectory,
                                                  in:FileManager.SearchPathDomainMask.userDomainMask).last!
        self.dispatch = DispatchQueue(label:"iturbide.codablehero", qos:DispatchQoS.background,
                                      attributes:DispatchQueue.Attributes.concurrent,
                                      autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                      target:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
    }
    
    func load<Model:Decodable>(path:String, completion:((Model) -> Void)?, error:((Error) -> Void)?) {
        let url:URL = self.directory.appendingPathComponent(path)
        self.dispatch.async { [weak self] in
            self?.load(url:url, completion:completion, error:error)
        }
    }
    
    func load<Model:Decodable>(bundle:Bundle, path:String, completion:((Model) -> Void)?, error:((Error) -> Void)?) {
        guard
            let url:URL = bundle.url(forResource:path, withExtension:nil)
        else {
            DispatchQueue.main.async { error?(CodableHeroError.invalidPath) }
            return
        }
        self.dispatch.async { [weak self] in
            self?.load(url:url, completion:completion, error:error)
        }
    }
    
    func save<Model:Encodable>(model:Model, path:String, completion:(() -> Void)?, error:((Error) -> Void)?) {
        let url:URL = self.directory.appendingPathComponent(path)
        self.dispatch.async { [weak self] in
            do {
                try self?.save(model:model, url:url)
                DispatchQueue.main.async { completion?() }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    func delete(path:String, completion:(() -> Void)?, error:((Error) -> Void)?) {
        let url:URL = self.directory.appendingPathComponent(path)
        self.dispatch.async { [weak self] in
            do {
                try self?.delete(url:url)
                DispatchQueue.main.async { completion?() }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    private func load<Model:Decodable>(url:URL, completion:((Model) -> Void)?, error:((Error) -> Void)?) {
        do {
            let model:Model = try self.load(url:url)
            DispatchQueue.main.async { completion?(model) }
        } catch let throwedError {
            DispatchQueue.main.async { error?(throwedError) }
        }
    }
    
    private func save<Model:Encodable>(model:Model, url:URL) throws {
        let data:Data = try JSONEncoder().encode(model)
        try self.delete(url:url)
        try data.write(to:url, options:Data.WritingOptions.atomic)
    }
    
    private func delete(url:URL) throws {
        if FileManager.default.fileExists(atPath:url.path) {
            try FileManager.default.removeItem(at:url)
        }
    }
    
    private func load<Model:Decodable>(url:URL) throws -> Model {
        guard FileManager.default.fileExists(atPath:url.path) else { throw CodableHeroError.fileNotFound }
        let data:Data = try Data(contentsOf:url, options:Data.ReadingOptions.uncached)
        return try JSONDecoder().decode(Model.self, from:data)
    }
}
