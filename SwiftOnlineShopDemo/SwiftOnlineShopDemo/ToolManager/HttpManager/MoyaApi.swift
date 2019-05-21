//
//  MoyaApi.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/5/7.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import Foundation
import Moya

let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<MoyaApi>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 10
        done(.success(request))
    } catch {
        return
    }
}

//普通的provider对象
let provider = MoyaProvider<MoyaApi>()
//设置了超时时间的provider对象
let requestTimeoutProvider = MoyaProvider<MoyaApi>(requestClosure: requestTimeoutClosure)

//请求方法
enum MoyaApi {
         //创建方法名和参数
    case categoryList(categoryId: String)
}

extension MoyaApi : TargetType {
    
    var baseURL: URL {
        return URL.init(string: "hostname")!//填写自己的主机地址
    }
    
    var path: String {
        switch self {
        case .categoryList:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categoryList:
            return .get
        }
    }
    
    //单元测试使用
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
        
    var task: Task {
        switch self {
        case .categoryList(let categoryId):
                //看服务端参数接受格式，json用JSONEncoding，url使用URLEncoding.default
                return .requestParameters(parameters: ["categoryId" : categoryId], encoding: URLEncoding.default)
            
        }
    }
        
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }

}
