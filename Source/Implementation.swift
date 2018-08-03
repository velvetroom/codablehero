import Foundation

class Implementation:CodableHero {
    private let directory:URL
    private let dispatch:DispatchQueue
    
    init() {
        self.directory = FileManager.default.urls(for:FileManager.SearchPathDirectory.documentDirectory,
                                                  in:FileManager.SearchPathDomainMask.userDomainMask).last!
        self.dispatch = DispatchQueue(label:"iturbide.codablehero", qos:DispatchQoS.background,
                                      attributes:DispatchQueue.Attributes.concurrent,
                                      autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency.inherit,
                                      target:DispatchQueue.global(qos:DispatchQoS.QoSClass.background))
    }
    
    func load<M:Decodable>(path:String, completion:((M) -> Void)?, error:((Error) -> Void)?) {
        self.dispatch.async { [weak self] in
            do {
                let m:M? = try self?.load(path:path)
                guard let model:M = m else { return }
                DispatchQueue.main.async { completion?(model) }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    func load<M:Decodable>(bundle:Bundle, path:String, completion:((M) -> Void)?, error:((Error) -> Void)?) {
        self.dispatch.async { [weak self] in
            do {
                let m:M? = try self?.load(bundle:bundle, path:path)
                guard let model:M = m else { return }
                DispatchQueue.main.async { completion?(model) }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    func save<M:Encodable>(model:M, path:String, completion:(() -> Void)?, error:((Error) -> Void)?) {
        self.dispatch.async { [weak self] in
            do {
                try self?.save(model:model, path:path)
                DispatchQueue.main.async { completion?() }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    func delete(path:String, completion:(() -> Void)?, error:((Error) -> Void)?) {
        self.dispatch.async { [weak self] in
            do {
                try self?.delete(path:path)
                DispatchQueue.main.async { completion?() }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    func load<M:Decodable>(path:String) throws -> M {
        let url:URL = self.directory.appendingPathComponent(path)
        return try self.load(url:url)
    }
    
    func load<M:Decodable>(bundle:Bundle, path:String) throws -> M {
        guard let url:URL = bundle.url(forResource:path, withExtension:nil) else { throw CodableHeroError.invalidPath }
        return try self.load(url:url)
    }
    
    func save<M:Encodable>(model:M, path:String) throws {
        let url:URL = self.directory.appendingPathComponent(path)
        let data:Data = try JSONEncoder().encode(model)
        try self.delete(path:path)
        try data.write(to:url, options:Data.WritingOptions.atomic)
    }
    
    func delete(path:String) throws {
        let url:URL = self.directory.appendingPathComponent(path)
        if FileManager.default.fileExists(atPath:url.path) {
            try FileManager.default.removeItem(at:url)
        }
    }
    
    private func load<M:Decodable>(url:URL) throws -> M {
        guard FileManager.default.fileExists(atPath:url.path) else { throw CodableHeroError.fileNotFound }
        let data:Data = try Data(contentsOf:url, options:Data.ReadingOptions.uncached)
        return try JSONDecoder().decode(M.self, from:data)
    }
}
