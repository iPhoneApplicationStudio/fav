//
//  PlaceDetailViewController.swift
//  Favorit
//
//  Created by Abhinay Maurya on 10/12/23.
//

import UIKit
import Lightbox
import NVActivityIndicatorView

class PlaceDetailViewControllerOld: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    var viewModel: PlaceDetailProtocol?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
        self.reloadScreen()
        self.fetchData()
    }
    
    //MARK: Private Methods
    private func initialSetting() {
        self.title = viewModel?.placeName
        self.collectionView.register(UINib(nibName: "FoodImageViewCell",
                                       bundle: nil),
                                 forCellWithReuseIdentifier: "FoodImageViewCell")
        self.pageController.numberOfPages = viewModel?.numnerOfIcons ?? 0
        self.collectionView.layer.borderWidth = 1
        self.collectionView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func reloadScreen() {
        DispatchQueue.main.async {[weak self] in
            guard let viewModel = self?.viewModel else {
                self?.labelCategory.isHidden = true
                self?.labelDistance.isHidden = true
                self?.labelAddress.isHidden = true
                self?.collectionView.isHidden = true
                self?.pageController.isHidden = true
                return
            }
            
            self?.labelCategory.isHidden = false
            self?.labelDistance.isHidden = false
            self?.labelAddress.isHidden = false
            self?.collectionView.isHidden = false
            self?.pageController.isHidden = false
            self?.setBookmarkState()
            
            self?.pageController.numberOfPages = viewModel.numnerOfIcons
            self?.labelCategory.text = viewModel.category ?? ""
            self?.labelAddress.text = viewModel.address ?? ""
            self?.labelDistance.text = viewModel.distance ?? ""
            self?.collectionView.reloadData()
        }
    }
    
    private func setBookmarkState() {
        let imageName = (viewModel?.isBookmarked ?? false) ? "bookmark1" : "bookmark0"
        DispatchQueue.main.async {[weak self] in
            self?.buttonBookmark.setImage(UIImage(named: imageName),
                                         for: .normal)
        }
    }
    
    private func fetchData() {
        guard let viewModel else {
            return
        }
        
        self.startActivityIndicator()
        viewModel.getPlace {[weak self] result in
            self?.stopActivityIndicator()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen()
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        self?.showError(message: (errorMessage))
                    }
                }
                
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
            case .none:
                break
            }
        }
    }
    
    private func startActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicatorView.isHidden = false
            self?.activityIndicatorView.startAnimating()
        }
    }
    
    private func stopActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            if self?.activityIndicatorView.isAnimating ?? false {
                self?.activityIndicatorView.isHidden = true
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    private func bookmarkThePlace() {
        guard let viewModel else {
            return
        }
    }
    
    private func removePlaceFormbookmark() {
        guard let viewModel else {
            return
        }
    
    }
    
    //MARK: IBAction
    @IBAction func pageController(_ sender: UIPageControl) {
        self.collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0),
                                         at: .centeredHorizontally,
                                         animated: true)
    }

    @IBAction func buttonBookmarkAction() {
        guard let viewModel else {
            return
        }
        
        let isBookmarked = viewModel.isBookmarked
        self.startActivityIndicator()
        if isBookmarked {
            self.removePlaceFormbookmark()
        } else {
            self.bookmarkThePlace()
        }
    }
}

extension PlaceDetailViewControllerOld: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numnerOfIcons ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodImageViewCell", for: indexPath) as? FoodImageViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imgUrl = viewModel.getIconUrlStringFor(index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let visible = collectionView.visibleCells.first else { return }
        guard let indexPath = collectionView.indexPath(for: visible)?.row else { return }
        self.pageController.currentPage = indexPath
    }
}
