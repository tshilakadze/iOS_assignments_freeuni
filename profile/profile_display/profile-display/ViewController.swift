//
//  ViewController.swift
//  profile-display
//
//  Created by Tsotne Shilakadze on 04.11.25.
//
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 1.0, alpha: 1.0)
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let profPicSize = screenWidth * 0.2
        let friendPicSize = profPicSize * 0.5
        
        let upperBackground = UIImageView(image: UIImage(named: "Background"))
        upperBackground.contentMode = .scaleAspectFill
        upperBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(upperBackground)
        view.sendSubviewToBack(upperBackground)

        NSLayoutConstraint.activate([
            upperBackground.topAnchor.constraint(equalTo: view.topAnchor),
            upperBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperBackground.heightAnchor.constraint(equalToConstant: screenHeight * 0.3)
        ])
        
        
        //Likes, following and followers
        let backgroundrect = UIView()
        backgroundrect.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        backgroundrect.layer.cornerRadius = 20
        backgroundrect.layer.masksToBounds = true
        view.addSubview(backgroundrect)
        backgroundrect.translatesAutoresizingMaskIntoConstraints = false
        
        let leftSide = UIStackView()
        let likesLbl = UILabel()
        let followingLbl = UILabel()
        let followersLbl = UILabel()
        let likesLbl1 = UILabel()
        let followingLbl1 = UILabel()
        let followersLbl1 = UILabel()
        
        likesLbl1.text = "Likes"
        followingLbl1.text = "Following"
        followersLbl1.text = "Followers"
        likesLbl1.textColor = .lightGray
        followingLbl1.textColor = .lightGray
        followersLbl1.textColor = .lightGray
        
        let likes = 11100, following = 1100, followers = 1200
        var likeString = String(likes)
        var followingString = String(following)
        var followersString = String(followers)
        if(likes >= 1000){
            let num = likes / 1000
            likeString = String(num)
            if((likes % 1000) / 100 != 0){
                likeString = likeString + "." + String((likes % 1000) / 100)
            }
            likeString = likeString + "K"
        }
        
        if(following >= 1000){
            let num = following / 1000
            followingString = String(num)
            if((following % 1000) / 100 != 0){
                followingString = followingString + "." + String((following % 1000) / 100)
            }
            followingString = followingString + "K"
        }

        if(followers >= 1000){
            let num = followers / 1000
            followersString = String(num)
            if((following % 1000) / 100 != 0){
                followersString = followersString + "." + String((following % 1000) / 100)
            }
            followersString = followersString + "K"
        }
        
        likesLbl.text = likeString
        followingLbl.text = followingString
        followersLbl.text = followersString
        
        likesLbl.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        followingLbl.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        followersLbl.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        likesLbl1.font = UIFont.systemFont(ofSize: 10)
        followingLbl1.font = UIFont.systemFont(ofSize: 10)
        followersLbl1.font = UIFont.systemFont(ofSize: 10)
        
        func makePair(_ top: UILabel, _ bottom: UILabel) -> UIStackView {
            let stack = UIStackView(arrangedSubviews: [top, bottom])
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 2
            return stack
        }
        
        let likesPair = makePair(likesLbl, likesLbl1)
        let followingPair = makePair(followingLbl, followingLbl1)
        let followersPair = makePair(followersLbl, followersLbl1)
        
        leftSide.addArrangedSubview(likesPair)
        leftSide.addArrangedSubview(followingPair)
        leftSide.addArrangedSubview(followersPair)
        leftSide.axis = .vertical
        leftSide.distribution = .equalCentering
        leftSide.alignment = .firstBaseline
        leftSide.spacing = screenHeight * 0.1
        view.addSubview(leftSide)
        leftSide.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundrect.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.035),
            backgroundrect.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.35),
            backgroundrect.widthAnchor.constraint(equalToConstant: screenWidth * 0.25),
            backgroundrect.heightAnchor.constraint(equalToConstant: screenHeight * 0.46),
            leftSide.centerXAnchor.constraint(equalTo: backgroundrect.centerXAnchor),
            leftSide.centerYAnchor.constraint(equalTo: backgroundrect.centerYAnchor),
        ])
        
        
        
        //Profile picture and follow-send
        let profPicBack = UIView()
        profPicBack.backgroundColor = .white
        profPicBack.layer.cornerRadius = 20
        profPicBack.layer.masksToBounds = true
        view.addSubview(profPicBack)
        profPicBack.translatesAutoresizingMaskIntoConstraints = false
        
        let profPicView = UIStackView()
        let profPic = LoadCirclePicture(imageName: "MyProfilePic", diameter: profPicSize)
        let name = UILabel()
        let phrase = UILabel()
        name.text = "Cat"
        phrase.text = "The Best Cat"
        name.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        phrase.textColor = .lightGray
        phrase.font = UIFont.systemFont(ofSize: 10)
        
        profPicView.addArrangedSubview(profPic)
        profPicView.addArrangedSubview(name)
        profPicView.addArrangedSubview(phrase)
        profPicView.axis = .vertical
        profPicView.distribution = .fill
        profPicView.alignment = .center
        profPicView.spacing = profPicSize * 0.125
        view.addSubview(profPicView)
        profPicView.translatesAutoresizingMaskIntoConstraints = false
        
        let followSend = UIStackView()
        let followButton = UIButton(type: .system)
        followButton.layer.cornerRadius = 10
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.masksToBounds = true;
        
        let sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .systemBlue
        sendButton.layer.masksToBounds = true
        
        followSend.addArrangedSubview(followButton)
        followSend.addArrangedSubview(sendButton)
        followSend.axis = .horizontal
        followSend.distribution = .fill
        followSend.spacing = screenWidth * 0.03125
        
        view.addSubview(followSend)
        followSend.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profPicBack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profPicBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.05 + profPicSize * 0.5),
            profPicBack.widthAnchor.constraint(equalToConstant: screenWidth * 0.9),
            profPicBack.heightAnchor.constraint(equalToConstant: profPicSize * 2),
            
            profPicView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profPicView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.05),
            followSend.centerXAnchor.constraint(equalTo: profPicBack.centerXAnchor),
            followSend.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.05 + profPicSize * 0.5 + profPicSize * 1.33),
            followSend.widthAnchor.constraint(equalToConstant: screenWidth * 0.9 * 0.9),
            followSend.heightAnchor.constraint(equalToConstant: profPicSize * 0.5)
        ])

        
        //Friends
        let friendsLbl = UILabel()
        friendsLbl.text = "Friends"
        friendsLbl.textColor = .black
        friendsLbl.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(friendsLbl)
        friendsLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendsLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.35),
            friendsLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.35)
        ])
        let friendPicsView = UIStackView()
        let friendPicOne = LoadCirclePicture(imageName: "FriendOne", diameter: friendPicSize)
        let friendPicTwo = LoadCirclePicture(imageName: "FriendTwo", diameter: friendPicSize)
        let friendPicThree = LoadCirclePicture(imageName: "FriendThree", diameter: friendPicSize)
        let friendPicFour = LoadCirclePicture(imageName: "FriendFour", diameter: friendPicSize)
        friendPicsView.addArrangedSubview(friendPicOne)
        friendPicsView.addArrangedSubview(friendPicTwo)
        friendPicsView.addArrangedSubview(friendPicThree)
        friendPicsView.addArrangedSubview(friendPicFour)
        friendPicsView.axis = .horizontal
        friendPicsView.distribution = .fill
        friendPicsView.alignment = .center
        friendPicsView.spacing = friendPicSize * 0.5
        view.addSubview(friendPicsView)
        friendPicsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendPicsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.35),
            friendPicsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.4)
        ])
        
        
        //Gallery
        let galleryLbl = UILabel()
        galleryLbl.text = "Gallery"
        galleryLbl.textColor = .black
        galleryLbl.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(galleryLbl)
        galleryLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            galleryLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.35),
            galleryLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.43 + friendPicSize)
        ])
        
        let postOne = UIImageView(image: UIImage(named: "PostOne"))
        let postTwo = UIImageView(image: UIImage(named: "PostTwo"))
        let postThree = UIImageView(image: UIImage(named: "PostThree"))
        let postFour = UIImageView(image: UIImage(named: "PostFour"))
        postOne.heightAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        postOne.widthAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        postTwo.heightAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        postTwo.widthAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        postThree.heightAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        postThree.widthAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        postFour.heightAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        postFour.widthAnchor.constraint(equalToConstant: friendPicSize * 2.75).isActive = true
        let postsFirst = UIStackView()
        let postsSecond = UIStackView()
        
        postOne.layer.cornerRadius = 20
        postOne.layer.maskedCorners = [.layerMinXMinYCorner]
        postOne.clipsToBounds = true
        
        postTwo.layer.cornerRadius = 20
        postTwo.layer.maskedCorners = [.layerMaxXMinYCorner]
        postTwo.clipsToBounds = true
        
        postThree.layer.cornerRadius = 20
        postThree.layer.maskedCorners = [.layerMinXMaxYCorner]
        postThree.clipsToBounds = true
        
        postFour.layer.cornerRadius = 20
        postFour.layer.maskedCorners = [.layerMaxXMaxYCorner]
        postFour.clipsToBounds = true

        postsFirst.addArrangedSubview(postOne)
        postsFirst.addArrangedSubview(postTwo)
        postsSecond.addArrangedSubview(postThree)
        postsSecond.addArrangedSubview(postFour)
        postsFirst.axis = .horizontal
        postsFirst.distribution = .fill
        postsFirst.alignment = .center
        postsFirst.spacing = screenWidth * 0.02
        postsSecond.axis = .horizontal
        postsSecond.distribution = .fill
        postsSecond.alignment = .center
        postsSecond.spacing = screenWidth * 0.02
        view.addSubview(postsFirst)
        postsFirst.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postsSecond)
        postsSecond.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postsFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.35),
            postsFirst.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.52),
            postsSecond.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.35),
            postsSecond.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.52 + friendPicSize * 2.75 + postsFirst.spacing)
        ])
    }
}
