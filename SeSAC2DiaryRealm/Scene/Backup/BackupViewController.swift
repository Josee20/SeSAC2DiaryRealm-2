//
//  BackupViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 이동기 on 2022/08/24.
//

import UIKit
import RealmSwift
import Zip


class BackupViewController: BaseViewController {
    
    let localRealm = try! Realm()
    
    let mainView = BackupView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2초뒤 자동 백업
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.backupButtonClicked()
//        }
        
        
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(BackupTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = closeButton
        
        mainView.backupButton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        mainView.restoreButton.addTarget(self, action: #selector(restoreButtonClicked), for: .touchUpInside)
    }
    
    @objc func backupButtonClicked() {
        
        var urlPaths = [URL]()
        
        // 1.도큐먼트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다", button: "확인")
            return
        }
        
        // 1-1. URL경로
        let realmFile = path.appendingPathComponent("default.realm")
        
        // 1-2 String으로 링크 확인
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업 파일이 없습니다")
            return
        }
        
        // 1-3 다시 URL로 바꿔 realmfile에 추가
        urlPaths.append(URL(string: realmFile.path)!)
        
        // 백업 파일을 압축 : URL
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSACDiary_1.zip")
            print("Archive Location: \(zipFilePath)")
            showActivityViewController()
            
        } catch {
            showAlertMessage(title: "압축을 실패했습니다")
        }
        
        // ActivityViewController 띄우기(성공했을 경우에만 띄워야함)
        
        
    }
    
    func showActivityViewController() {
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다", button: "확인")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("SeSACDiary_1.zip")
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
    @objc func restoreButtonClicked() {
        
        // [.archive] : 다른 파일을 복사해올 가능성을 줄여줌
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker, animated: true)
    }
    

    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    
}

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BackupTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .darkGray
        return cell
    }
}

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // 파일 URL확인
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일에 오류가 있습니다.")
            return
        }
        
        // document 위치 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가있습니다")
            return
        }
        
        // 파일이름과 확장자 즉 최종 경로를 가져옴
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        // 이미 있는 경우 fileapp 에서 가져올 필요없이 그냥 경로에서 압축 풀어주면됨
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다")
            }
            
        } else {
            
            do {
                // 파일 앱의 zip -> 도큐먼트 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                    
                let fileURL = path.appendingPathComponent("SeSACDiary_1.zip") // 폴더 생성, 폴더 안에 파일 저장
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                })
                
                
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        }
        
        
    }
}
