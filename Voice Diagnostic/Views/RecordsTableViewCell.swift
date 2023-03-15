//
//  RecordsTableViewCell.swift
//  Voice Diagnostic
//
//  Created by Dmytro Vasylenko on 17.01.2023.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {
    
    private let backgroundCell: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recordBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recordImageView: UIImageView = {
        let imageVeiew = UIImageView()
        imageVeiew.contentMode = .scaleAspectFit
        imageVeiew.tintColor = .black
        imageVeiew.image = UIImage(named: "microphone")?.withRenderingMode(.alwaysTemplate)
        imageVeiew.translatesAutoresizingMaskIntoConstraints = false
        return imageVeiew
    }()
    
    private var recordNameLable: UILabel = {
        let lable = UILabel(text: "", font: .systemFont(ofSize: 22), fontColor: .black, lines: 0)
        lable.textAlignment = .right
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(backgroundCell)
        addSubview(recordBackgroundView)
        recordBackgroundView.addSubview(recordImageView)
        addSubview(recordNameLable)
    }
    
    public func setRecordName(text: String){
        recordNameLable.text = text
    }
}

// MARK: - Constraints
extension RecordsTableViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
       
            recordBackgroundView.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            recordBackgroundView.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 5),
            recordBackgroundView.heightAnchor.constraint(equalToConstant: 38),
            recordBackgroundView.widthAnchor.constraint(equalToConstant: 38),
        
            recordImageView.topAnchor.constraint(equalTo: recordBackgroundView.topAnchor, constant: 10),
            recordImageView.leadingAnchor.constraint(equalTo: recordBackgroundView.leadingAnchor, constant: 10),
            recordImageView.trailingAnchor.constraint(equalTo: recordBackgroundView.trailingAnchor, constant: -10),
            recordImageView.bottomAnchor.constraint(equalTo: recordBackgroundView.bottomAnchor, constant: -10),
 
            recordNameLable.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 12),
            recordNameLable.leadingAnchor.constraint(equalTo: recordImageView.trailingAnchor, constant: -20),
            recordNameLable.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10)
        ])
        
    }
}

