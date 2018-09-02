import Foundation

public class CodableHero {
    private let directory = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask).last!
    private let dispatch = DispatchQueue(label:String(), qos:.background, attributes:.concurrent,
                                         target:.global(qos:.background))
    
    public init() { }
    
    public func load<M:Decodable>(path:String, completion:((M) -> Void)?, error:((Error) -> Void)?) {
        dispatch.async { [weak self] in
            do {
                guard let model:M = try self?.load(path:path) else { return }
                DispatchQueue.main.async { completion?(model) }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    public func load<M:Decodable>(bundle:Bundle, path:String, completion:((M) -> Void)?, error:((Error) -> Void)?) {
        dispatch.async { [weak self] in
            do {
                guard let model:M = try self?.load(bundle:bundle, path:path) else { return }
                DispatchQueue.main.async { completion?(model) }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    public func save<M:Encodable>(model:M, path:String, completion:(() -> Void)?, error:((Error) -> Void)?) {
        dispatch.async { [weak self] in
            do {
                try self?.save(model:model, path:path)
                DispatchQueue.main.async { completion?() }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    public func delete(path:String, completion:(() -> Void)?, error:((Error) -> Void)?) {
        dispatch.async { [weak self] in
            do {
                try self?.delete(path:path)
                DispatchQueue.main.async { completion?() }
            } catch let throwedError {
                DispatchQueue.main.async { error?(throwedError) }
            }
        }
    }
    
    public func load<M:Decodable>(path:String) throws -> M {
        return try load(url:directory.appendingPathComponent(path))
    }
    
    public func load<M:Decodable>(bundle:Bundle, path:String) throws -> M {
        guard let url = bundle.url(forResource:path, withExtension:nil) else { throw CodableHeroError.invalidPath }
        return try load(url:url)
    }
    
    public func save<M:Encodable>(model:M, path:String) throws {
        let url = directory.appendingPathComponent(path)
        let data = try JSONEncoder().encode(model)
        try delete(path:path)
        try data.write(to:url, options:.atomic)
    }
    
    public func delete(path:String) throws {
        let url = directory.appendingPathComponent(path)
        if FileManager.default.fileExists(atPath:url.path) {
            try FileManager.default.removeItem(at:url)
        }
    }
    
    private func load<M:Decodable>(url:URL) throws -> M {
        guard FileManager.default.fileExists(atPath:url.path) else { throw CodableHeroError.fileNotFound }
        return try JSONDecoder().decode(M.self, from:try Data(contentsOf:url, options:.uncached))
    }
}
