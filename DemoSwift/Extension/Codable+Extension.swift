//
//  Codable+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/30.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import Foundation

public extension Encodable {
    /// 对象转成JSON字符串
    ///
    /// - Returns: 成功返回json字符串，失败返回nil
    public func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    /// 对象转成JSON对象
    ///
    /// - Returns: 成功返回json对象，失败返回nil
    public func toJSONObject() -> Any? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}

public extension Decodable {
    /// json字符串解析成model(struct/class)
    ///
    /// - Parameters:
    ///   - string: json字符串
    ///   - designatedPath: 子路径，以"."分隔
    /// - Returns: 解析成的model
    public func decodeJSON(from string: String?, designatedPath: String? = nil) -> Self? {
        guard let jsonData = string?.data(using: .utf8) else { return nil }
        
        guard let jsonObj = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) else {
            return nil
        }
        
        guard let jsonDic = jsonObj as? [String: Any] else {
            return nil
        }
        
        if let innerJsondic = getInnerObject(inside: jsonDic, by: designatedPath), let data = try? JSONSerialization.data(withJSONObject: innerJsondic, options: []) {
            return try? JSONDecoder().decode(Self.self, from: data)
        }
        
        return nil
    }
    
    /// json对象解析成model(struct/class)
    ///
    /// - Parameters:
    ///   - object: json对象，可以是字符串，字典，Data
    ///   - designatedPath: 子路径，以"."分隔
    /// - Returns: 解析成的model
    public func decodeJSON(from object: Any?, designatedPath: String? = nil) -> Self? {
        guard let _object = object, let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 else { return nil }
        
        guard JSONSerialization.isValidJSONObject(_object) else {
            return nil
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: _object, options: []),
            let jsonObj = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return nil }
        
        if let jsonDic = getInnerObject(inside: jsonObj, by: designatedPath), let jsonData = try? JSONSerialization.data(withJSONObject: jsonDic, options: []) {
            return try? JSONDecoder().decode(Self.self, from: jsonData)
        }
        
        return nil
    }
}

fileprivate func getInnerObject(inside object: Any?, by designatedPath: String?) -> Any? {
    var result: Any? = object
    var abort = false
    
    if let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 {
        var next = object as? [String : Any]
        paths.forEach({ (seg) in
            if seg.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return
            }
            
            if let _next = next?[seg] {
                result = _next
                next = _next as? [String: Any]
            } else {
                abort = true
            }
        })
    }
    
    return abort ? nil : result
}
