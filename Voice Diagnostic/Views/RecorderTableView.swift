//
//  RecorderTableView.swift
//  Voice Diagnostic
//
//  Created by Dmytro Vasylenko on 24.01.2023.
//

import UIKit
import AVFoundation

class RecorderTableView: UITableView {
    
    private let idRecordsTableviewCell = "idRecordsTableviewCell"
    private var recordingsArray = [Recording]()
    private var audioPlayer: AVAudioPlayer!
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setDelegates()
        register(RecordsTableViewCell.self, forCellReuseIdentifier: idRecordsTableviewCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        separatorStyle = .none
        bounces = false
        showsVerticalScrollIndicator = false
        delaysContentTouches = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegates() {
        delegate = self
        dataSource = self
    }
    
// MARK: - Data
    public func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }
    
    func loadRecordings() {
        self.recordingsArray.removeAll()
        let filemanager = FileManager.default
        let documentsDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let paths = try filemanager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            for path in paths {
                let recording = Recording(name: path.lastPathComponent, path: path)
                self.recordingsArray.append(recording)
            }
            self.reloadData()
        } catch {
            print(error)
        }
    }
    
// MARK: - Playback
    func isPlaying() -> Bool {
        if let player = self.audioPlayer {
            return player.isPlaying
        }
        return false
    }
    
    func play(url: URL) {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.caf.rawValue)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        if let player = self.audioPlayer {
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        }
        //TODO: - Add textLabel animation during playing record
    }
    
    func stopPlay() {
        if let paths = self.indexPathsForSelectedRows {
            for path in paths {
                self.deselectRow(at: path, animated: true)
            }
        }
        if let player = self.audioPlayer {
            player.pause()
        }
        self.audioPlayer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
    }
}

//MARK: - UITableViewDataSource
extension RecorderTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = self.recordingsArray.count
        if result > 0 {
            self.isHidden = false
        }
        else {
            self.isHidden = true
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idRecordsTableviewCell, for: indexPath) as? RecordsTableViewCell else {
            return UITableViewCell()
        }
        let recording = self.recordingsArray[indexPath.row]
        cell.setRecordName(text: "\(recording.name)")
        cell.detailTextLabel?.text = recording.path.absoluteString
        return cell
    }
}

//MARK: - UITableViewDelegate
extension RecorderTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isPlaying() {
            self.stopPlay()
        }
        let recording = self.recordingsArray[indexPath.row]
        self.play(url: recording.path)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction (style: .destructive, title: "" ) { _, _, _ in
            let filemanager = FileManager.default
            let recording = self.recordingsArray[indexPath.row]
            do {
                try filemanager.removeItem(at: recording.path)
                self.recordingsArray.remove(at: indexPath.row)
                self.reloadData()
            } catch(let err) {
                print("Error while deleteing \(err)")
            }
        }
        action.backgroundColor = .black
        action.image = UIImage(named: "delete")
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: AVAudioPlayerDelegate
extension RecorderTableView: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        self.stopPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlay()
    }
}


