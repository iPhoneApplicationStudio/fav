//
//  ShareDialogViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 8/22/18.
//  Copyright © 2018 Bushman Studio. All rights reserved.
//

import UIKit

class ShareDialogViewController: UIViewController {
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var shareTitleLabel: UILabel!
    
    var venueName = "this venue"
    var placeholderString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareTitleLabel.text = "Share \(venueName)" 
        placeholderString = Message.share.value + venueName
        commentTextView.delegate = self
        commentTextView.text = placeholderString
        commentTextView.textColor = UIColor.lightGray
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension ShareDialogViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderString
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
}
