//
//  MainVC.swift
//  Tutorial_002
//
//  Created by 위대연 on 2020/04/27.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    enum ButtonTag:Int {
        case clear = 10
        case get
        case post
    }
    
    @IBOutlet weak var textView:UITextView!
    
    @IBOutlet weak var clearButton:UIButton!
    @IBOutlet weak var getButton:UIButton!
    @IBOutlet weak var postButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearTextView()
        self.buttonInit()
    }
    
    func buttonInit() {
        self.clearButton.tag = ButtonTag.clear.rawValue
        self.clearButton.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        
        self.getButton.tag = ButtonTag.get.rawValue
        self.getButton.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        
        self.postButton.tag = ButtonTag.post.rawValue
        self.postButton.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
    }
    func clearTextView() {
        textView.text = "비어진 정보창"
    }
    
    @objc func touchUpButton(_ sender:UIButton) {
        if let selected = ButtonTag(rawValue: sender.tag) {
            switch selected {
            case .clear: self.clearTextView()
            case .get: self.getBlogInfo()
            case .post: self.openPostBox()
            }
        }
    }
    
    func getBlogInfo() {
        let net = TestNet()
        net.getBlogInfo { (result) in
            self.textView.text += "\n"
            self.textView.text += result.string()
        }
    }
    
    
    func openPostBox() {
        if let vc = self.storyboard?.instantiateViewController(identifier: PostTextVC.sb_id) as? PostTextVC{
            vc.calldVc = self
            self.present(vc, animated: true)
        } else {
            print("err 찾을 수 없는 vc")
        }
    }

}
