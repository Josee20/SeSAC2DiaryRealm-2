//
//  ImageSearchViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit
import Kingfisher

class SearchImageViewController: BaseViewController {

    var delegate: SelectImageDelegate?
    
    var selectedImage: UIImage?
    var selectIndexPath: IndexPath?
    
    let mainView = ImageSearchView()

    override func loadView() {
        self.view = mainView
    }
    
    var imageList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.BaseColor.background
        
    }

    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ImageSearchCollectionViewCell.self, forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        let selectButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectButtonClicked))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = selectButton
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func selectButtonClicked() {
        
        guard let selectedImage = selectedImage else {
            showAlertMessage(title: "사진을 선택해주세요", button: "확인")
            return
        }
        
        print(selectedImage)
        
        delegate?.sendImageData(image: selectedImage)
        dismiss(animated: true)
    }
    
}
 
extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageDummy.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.layer.borderWidth = selectIndexPath == indexPath ? 4 : 0
        cell.layer.borderColor = selectIndexPath == indexPath ? Constants.BaseColor.point.cgColor : nil
        
        cell.setImage(data: ImageDummy.data[indexPath.item].url)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //어떤 셀인지 어떤 이미지를 가지고 올 지 어떻게 알까?
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageSearchCollectionViewCell else { return }
        
        selectedImage = cell.searchImageView.image
//        cell.layer.borderWidth = 2
//        cell.layer.borderColor = UIColor.blue.cgColor
//        
    
        selectIndexPath = indexPath
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectIndexPath = nil
        selectedImage = nil
        
        collectionView.reloadData()
    }
}

