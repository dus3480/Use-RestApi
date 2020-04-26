//
//  PostTextVC.swift
//  Tutorial_002
//
//  Created by 위대연 on 2020/04/27.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit

class PostTextVC: UIViewController {
    static let sb_id = "sb_id_post_text"
    
    enum ButtonTag : Int {
        case send = 10
        case cancel
    }
    
    @IBOutlet weak var codeTextField:UITextField!
    @IBOutlet weak var textTextField:UITextField!
    @IBOutlet weak var sendButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    
    var calldVc:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonInit()
        self.textfieldInit()
    }
    
    func buttonInit() {
        self.cancelButton.tag = ButtonTag.cancel.rawValue
        self.sendButton.tag = ButtonTag.send.rawValue
        
        self.cancelButton.addTarget(self, action: #selector(touchUpButotn(_:)), for: .touchUpInside)
        self.sendButton.addTarget(self, action: #selector(touchUpButotn(_:)), for: .touchUpInside)
    }
    
    func textfieldInit() {
        self.textTextField.delegate = self
        self.codeTextField.delegate = self
    }
    
    @objc func touchUpButotn(_ sender:UIButton) {
        if let selected = ButtonTag(rawValue: sender.tag) {
            switch selected {
            case .send: self.sendAction()
            case .cancel: self.cancelAction()
            }
        }
    }
    
    func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendAction() {
        if let pvc = calldVc as? MainVC {
            let net = TestNet()
            let code_string = self.codeTextField.text ?? ""
            let code = Int(code_string)
            let text = self.textTextField.text ?? ""
            
            if code == nil {
                let alert = UIAlertController(title: nil, message: "올바른 code를 입력해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let sending = net.postText(code: code!, text: text) { (result) in
                    pvc.textView.text += result
                    self.dismiss(animated: true, completion: nil)
                }
                pvc.textView.text += "\n\(sending)\n"
            }
        }
    }
}
extension PostTextVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
