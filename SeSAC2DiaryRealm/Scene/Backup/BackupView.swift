//
//  BackupView.swift
//  SeSAC2DiaryRealm
//
//  Created by 이동기 on 2022/08/24.
//

import UIKit

class BackupView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        return view
    }()
    
    let backupButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업하기", for: .normal)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    let restoreButton: UIButton = {
        let view = UIButton()
        view.setTitle("복구하기", for: .normal)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    override func configureUI() {
        self.addSubview(backupButton)
        self.addSubview(restoreButton)
        self.addSubview(tableView)
        
        
        
    }
    
    
    
    
    override func setConstraints() {
        
        backupButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(60)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            
        }
        
        restoreButton.snp.makeConstraints { make in
            
            make.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(60)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide)
            make.bottomMargin.equalTo(backupButton.snp.top).offset(-12)
            
        }
    }
}
