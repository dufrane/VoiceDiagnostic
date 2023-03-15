//
//  RecorderViewController.swift
//  Voice Diagnostic
//
//  Created by Dmytro Vasylenko on 14.01.2023.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController {
    private let recorderLabel = UILabel(text: "Voice Recorder",
                                      font: .systemFont(ofSize: 28,weight: .bold),
                                      fontColor: .white, lines: 1)
    
    private let hintLabel = UILabel(text: "Please press record button and read this text loudly",
                                   font: .systemFont(ofSize: 12), fontColor: .white, lines: 1)

    private let textLabel = UILabel(text: "How much wood would a woodchuck chuck if a woodchuck could chuck wood?",
                                    font: .systemFont(ofSize: 22), fontColor: .white, lines: 0)
        
    private var recordButton: RecordButton?
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var tableView = RecorderTableView()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.tableView.isPlaying() {
            self.tableView.stopPlay()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let recordButtonSide = self.view.bounds.size.height / 12
        recordButton = RecordButton(frame: CGRect(x: self.view.bounds.width / 2 - recordButtonSide / 2,
                                                  y: self.view.bounds.height - recordButtonSide * 1.3,
                                                  width: recordButtonSide,
                                                  height: recordButtonSide))
        recordButton?.delegate = self
        self.view.addSubview(recordButton!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { _ in
            }
        } catch {
            // failed to record!
        }
        setupViews()
        setConstraints()
        tableView.loadRecordings()
    }
    
    private func setupViews() {
        view.addSubview(recorderLabel)
        view.addSubview(hintLabel)
        view.addSubview(textLabel)
        view.addSubview(tableView)
    }
    
// MARK: - Recording
    private func startRecording() {
        let date = Date()
        let calendar = Calendar.current
        let audioFilename = tableView.getDocumentsDirectory().appendingPathComponent("\(calendar.component(.hour, from: date)):"+"\(calendar.component(.minute, from: date)):"+"\(calendar.component(.second, from: date))"+".m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
        //TODO: Add animation of bitrate of record
    }
    
   private func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        tableView.loadRecordings()
    }
}

// MARK: - AVAudioRecorderDelegate
extension RecorderViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

// MARK: - RecordButtonDelegate
extension RecorderViewController: RecordButtonDelegate {
    func tapButton(isRecording: Bool) {
        if audioRecorder == nil && isRecording {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}

// MARK: - Constraints
extension RecorderViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            recorderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            recorderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recorderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
            hintLabel.topAnchor.constraint(equalTo: recorderLabel.bottomAnchor, constant: 40),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textLabel.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 15),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}
