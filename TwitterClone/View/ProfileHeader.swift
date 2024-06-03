//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 18/02/23.
//

import Foundation
import UIKit

protocol ProfileHeaderDelegate: class {
    func dissmissView()
    func handleProfileEditFolloe(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    // -MARK: Properties
    weak var profileDelegate: ProfileHeaderDelegate?
    private let filterBar = ProfileFilterView()
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(customBackButton)
        customBackButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        customBackButton.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var customBackButton: UIButton = {
        let button = UIButton(type: .system)
        let img = UIImage(systemName: "arrow.left")
        button.setImage(img?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleDissmiss), for: .touchUpInside)
        button.tintColor = .white
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        
        return iv
    }()
    
    let editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        
        return button
    }()
    
    private let fullNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        
        return lbl
    }()
    
    private let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = .lightGray
        
        return lbl
    }()
    
    private let bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 3
        lbl.text = "This is a first bio label, so I'm testing if this works or not hahaha"
        
        return lbl
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    }()
    
    // -MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36/2
        
        let userDetialtack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel, bioLabel])
        userDetialtack.axis = .vertical
        userDetialtack.distribution = .fillProportionally
        userDetialtack.spacing = 4
        
        addSubview(userDetialtack)
        userDetialtack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let followedStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followedStack.axis = .horizontal
        followedStack.spacing = 8
        followedStack.distribution = .fillEqually
        
        addSubview(followedStack)
        followedStack.anchor(top: userDetialtack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width/3, height: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // -MARK: Selector
    @objc func handleDissmiss() {
        profileDelegate?.dissmissView()
    }
    
    @objc func handleEditProfileFollow() {
        profileDelegate?.handleProfileEditFolloe(self)
    }
    
    @objc func handleFollowTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    // -MARK: Helpers
    func configure() {
        guard let user = user else { return }
        
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullNameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
}

// -MARK: ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate{
    func filterViewAnimate(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        
        let xPos = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPos
        }
    }
}
