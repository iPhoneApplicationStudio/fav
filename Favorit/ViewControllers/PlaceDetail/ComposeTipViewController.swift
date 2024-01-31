//
//  ComposeTipViewController.swift
//  Favorit
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

protocol ComposeTipViewDelegate: AnyObject {
    func bookmarkedTheVenue()
    func noteUpdated(note: Note)
}

class ComposeTipViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tipTextView: UITextView!
    @IBOutlet weak var tipDoneButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    private var placeholderText: String?
    private var didBeginEditing = false
    var viewModel: ComposeNoteProtocol?
    weak var composeTipViewDelegate: ComposeTipViewDelegate?

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    //MARK: Private Methods
    private func initialSetting() {
        tipDoneButton.layer.cornerRadius = tipDoneButton.frame.height / 2
        tipDoneButton.clipsToBounds = true
        
        tipTextView.delegate = self
        tipTextView.layer.cornerRadius = 5.0
        tipTextView.layer.borderWidth = 1.0
        tipTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.setPlaceholderText()
        guard let viewModel else {
            tipTextView.textColor = .lightGray
            tipTextView.text = placeholderText
            return
        }
        
        if let note = viewModel.currentNote?.note {
            tipTextView.text = note
        } else {
            tipTextView.textColor = .lightGray
            tipTextView.text = placeholderText
        }
    }
    
    private func saveTheNote(noteText: String) {
        guard let viewModel else {
            return
        }
        
        self.view.endEditing(true)
        self.activityIndicatorView.start()
        viewModel.saveNote(noteString: noteText) {[weak self] result in
            self?.activityIndicatorView.stop()
            switch result {
            case .success(let note):
                self?.composeTipViewDelegate?.noteUpdated(note: note)
            case.failure(let error):
                self?.showError(message: (error.localizedDescription))
            }
        }
    }
    
    private func bookmarkTheVenue() {
        guard let viewModel else {
            return
        }
        
        self.view.endEditing(true)
        self.activityIndicatorView.start()
        viewModel.addToBookmark {[weak self] result in
            self?.activityIndicatorView.stop()
            switch result {
            case .success(let flag):
                if flag {
                    self?.composeTipViewDelegate?.bookmarkedTheVenue()
                } else {
                    self?.showError(message: viewModel.errorMessage)
                }
            case.failure(let error):
                self?.showError(message: (error.localizedDescription))
            }
        }
    }
    
    private func setPlaceholderText() {
        let venueNameString = viewModel?.placeName ?? "this venue"
        self.placeholderText = "Click here to add a note about \(venueNameString) before you bookmark (280 Characters)"
    }
    
    //MARK: IBAction
    @IBAction func didClickOnSaveVenue() {
        guard let text = tipTextView.text, text.isNotEmpty, text != placeholderText else {
            self.bookmarkTheVenue()
            return
        }
        
        self.saveTheNote(noteText: text)
    }
}

//MARK: TextView Delegate
extension ComposeTipViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, 
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 280
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            didBeginEditing = true
            textView.text = nil
            textView.textColor = .primaryColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}

extension ComposeTipViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Bookmark")
    }
}

extension ComposeTipViewController {
    static func getViewController(viewModel: ComposeNoteProtocol) -> ComposeTipViewController? {
        let composeTipViewController = UIStoryboard(name: StoryboardName.main.value,
                            bundle: nil).instantiateViewController(withIdentifier: "composeTipsVC") as? ComposeTipViewController
        composeTipViewController?.viewModel = viewModel
        return composeTipViewController
    }
}
