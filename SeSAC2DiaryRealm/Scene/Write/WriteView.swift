//
//  WriteView.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/21.
//

import UIKit

class WriteView: BaseView {
   
    
    
    let userImageView: DiaryImageView = {
        let view = DiaryImageView(frame: .zero)
        return view
    }()
    
    let titleTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "제목을 입력해주세요"
        view.textColor = .white
        
        return view
    }()
    
    let dateTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "날짜를 입력해주세요"
        
        view.textColor = .white
        return view
    }()
    
    let contentTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 14)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    let searchImageButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "photo"), for: .normal)
        view.tintColor = Constants.BaseColor.text
        view.backgroundColor = Constants.BaseColor.point
        view.layer.cornerRadius = 25
        return view
    }()
    
    let cancelButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemGray4
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .red
        return view
    }()
    
    let saveButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemGray5
        view.setTitle("저장", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        return view
    }()
    
    // MARK: - Methods
    override func configureUI() {
        [userImageView, titleTextField, dateTextField, contentTextView, searchImageButton, cancelButton, saveButton].forEach {
            self.addSubview($0)
        }
    }
     
    override func setConstraints() {
        
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.topMargin.equalTo(userImageView.snp.top).offset(0)
            make.trailingMargin.equalTo(userImageView.snp.trailing).offset(0)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(55)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottomMargin.equalTo(saveButton.snp.top).offset(-10)
        }
        
        searchImageButton.snp.makeConstraints { make in
            make.trailing.equalTo(userImageView.snp.trailing).offset(-12)
            make.bottom.equalTo(userImageView.snp.bottom).offset(-12)
            make.width.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.bottomMargin.equalTo(-10)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            
        }
    }

}
