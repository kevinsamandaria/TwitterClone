//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 14/12/22.
//

import UIKit
import Firebase
import SwiftUI

class MainTabController: UITabBarController {
    
    // -MARK: Properties
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // -MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    // -MARK: API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut(){
        do{
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // -MARK: Selector
    @objc func actionButtonTapped(){
        guard let user = user else { return }
        let controller = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // -MARK: Helper
    func configureUI() {
        view.addSubview(actionButton)
        configureViewController()
    }
    
    func configureViewController() {
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNav = navigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreContorller()
        let exploreNav = navigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notification = NotificationController()
        let notifeNav = navigationController(image: UIImage(named: "like_unselected"), rootViewController: notification)
        
        let message = MessageController()
        let msgNav = navigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: message)
        
        viewControllers = [feedNav, exploreNav, notifeNav, msgNav]
    }
    
    func navigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
}

struct MainView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //leave this empty
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        MainTabController()
    }
}

struct MainView_PreviewView: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

