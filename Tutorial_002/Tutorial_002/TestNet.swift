//
//  TestNet.swift
//  Tutorial_002
//
//  Created by 위대연 on 2020/04/27.
//  Copyright © 2020 위대연. All rights reserved.
//

import Foundation
import Alamofire

class TestNet {
    let server = "http://127.0.0.1:5000"
    let getBlogInfoUrl = "/api/blog-info"
    let postTextUrl = "/api/post-text"
    
    struct BlogInfo {
        let name:String
        let link:String
        let des:String
        
        func string() -> String{
            "name:\(name)\nlink:\(link)\ndes:\(des)"
        }
    }
    
    func getBlogInfo(_ complet:@escaping (BlogInfo)->Void ) {
        
        Alamofire.request(URL(string: "\(server)\(getBlogInfoUrl)")!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print("TestNet getBlogInfo err : \(err.localizedDescription)")
            case .success(let result):
                if let root = result as? [String:Any] {
                    let status = root["result"] as? String ?? "fail"
                    guard status != "fail" else {
                        complet(BlogInfo(name: "fail", link: "fail", des: "status error"))
                        return
                    }
                    
                    let des = root["des"] as? String ?? ""
                    let link = root["link"] as? String ?? ""
                    let name = root["name"] as? String ?? ""
                    
                    complet(BlogInfo(name: name, link: link, des: des))
                } else {
                    complet(BlogInfo(name: "fail", link: "fail", des: "올바른 형식이 아닙니다."))
                }
            }
        }
    }
    
    func postText(code:Int, text:String, _ complet:@escaping (String)->Void ) -> String {
        guard code < 5000, text.count < 500 else {
            return "형식 지정 오류"
        }
        
        let param:Parameters = ["code":code,"text":text]
        Alamofire.request(URL(string: "\(server)\(postTextUrl)")!, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print("TestNet postText err : \(err.localizedDescription)")
            case .success(let result):
                if let root = result as? [String:Any] {
                    let status = root["result"] as? String ?? "fail"
                    guard status != "fail" else {
                        complet("0000:Err, status error")
                        return
                    }
                    
                    let code = root["code"] as? Int ?? 0
                    let text = root["text"] as? String ?? ""
                    complet("\(code):\(text)")
                } else {
                    complet("0000:Err,형식오류")
                }
            }
        }
        return "요청 시작"
    }
    
}
