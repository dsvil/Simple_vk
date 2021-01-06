//
//  NewsCell.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 03.01.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    
    //MARK: Properties
    

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = """
                         Some information hered fgdgsdgfsdfgsdfgs sdfgsdfgsdfhsdjsdfghwrthtrjsdfgsfgjsdfg sdfgsdhtrwgdfshsfgjsdfhgsjsdfhs dfasdfasdf dsfasdf asdfasdf gqergqewr gqrgqerg qergeqrg qerg eqrgqe rhqerh eqrg qerhg eheqrhg qerhgeqr hqerh qerh qerh eqgeqrh qerh eqrh eqrh qer hdfagdwg sd fhwerh qerheqhgrh eqrh sdfhqe rhqer hq
                         """
        return label
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Здесь обычно идет название сообщества"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дату можно?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let mainImage: UIImageView = {
        let iv = UIImageView()

        iv.backgroundColor = .red
        return iv
    }()
    
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 30, height: 20)
        button.addTarget(self, action: #selector(handShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor,
                     right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8)
        
        
        let captionStack = UIStackView(arrangedSubviews: [captionLabel, mainImage])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 10
        addSubview(captionStack)
        mainImage.setDimensions(width: frame.width, height: frame.width * 0.7)
        captionStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor,
                     right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8)
        
        
        let actionStack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.alignment = .leading
        actionStack.spacing = 90
        addSubview(actionStack)
        actionStack.isUserInteractionEnabled = true
        actionStack.anchor(top: captionStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 12, paddingLeft: 20, paddingBottom: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    @objc func handleCommentTapped() {
    }
    
    @objc func handleLikeTapped() {
    }
    
    @objc func handShareTapped() {
    }
    
    //MARK: Helpers
    
    func configure() {
    
    }
    
}
