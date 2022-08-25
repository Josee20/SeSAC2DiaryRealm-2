//
//  WriteViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit
import RealmSwift //Realm 1.

protocol SelectImageDelegate {
    func sendImageData(image: UIImage)
}

class WriteViewController: BaseViewController {

    let mainView = WriteView()
    let localRealm = try! Realm() //Realm 2. Realm 테이블에 데이터를 CRUD할 때, Realm 테이블 경로에 접근
    
    override func loadView() {
        self.view = mainView
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = closeButton
        
    }
    
    override func configure() {
        mainView.searchImageButton.addTarget(self, action: #selector(selectImageButtonClicked), for: .touchUpInside)
        mainView.saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    
    // Realm + 이미지 도큐먼트 저장
    @objc func saveButtonClicked() {

        guard let title = mainView.titleTextField.text else {
            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
        }

        let task = UserDiary(diaryTitle: title, diaryContent: "\(mainView.contentTextView.text!)", diaryDate: Date(), regdate: Date(), photo: nil)

        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }

        if let image = mainView.userImageView.image {
            saveImageToDocument(fileName: "\(task.objectId).jpg", image: image)
        }

        dismiss(animated: true)
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부 경로. 이미지 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } //용량줄이기
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
    
    //Realm Create Sample
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
      
    @objc func selectImageButtonClicked() {
        let vc = SearchImageViewController()
        vc.delegate = self
        transition(vc, transitionStyle: .presentNavigation)
        
    }
}

extension WriteViewController: SelectImageDelegate {
    
    // 언제 실행되면 될까? -> 선택버튼 누를때
    func sendImageData(image: UIImage) {
        mainView.userImageView.image = image
        print(#function)
    }

}
