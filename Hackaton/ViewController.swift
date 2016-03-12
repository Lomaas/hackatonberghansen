//
//  ViewController.swift
//  Hackaton
//
//  Created by Simen Johannessen on 11/03/16.
//  Copyright © 2016 lomas. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit


enum VideoType {
    case network
    case disc
}

class ViewController: UIViewController
{
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    var joinViewController: BookTripViewController!
    
    @IBAction func didPressJoin(sender: AnyObject)
    {
        joinViewController = storyboard?.instantiateViewControllerWithIdentifier("BookTripViewController") as! BookTripViewController
        joinViewController.delegate = self
        joinViewController.view.frame = CGRectMake(10, view.bounds.height + 50, self.view.bounds.width - 20, 300)
        
        view.addSubview(joinViewController.view)
        addChildViewController(joinViewController)
        joinViewController.didMoveToParentViewController(self)

        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.joinViewController.view.frame.origin.y = 100
            self.baseScrollView.alpha = 0.3
            self.baseScrollView.backgroundColor = UIColor.blackColor()
        }

    }
    
    private let images = [
        UIImageView(image: UIImage(named: "Dracula_Gradient")),
        UIImageView(image: UIImage(named: "Dracula_bilde2"))
    ]
    
    private let videos = [
        (url: "video", type: VideoType.disc),
        (url: "festival", type: VideoType.disc)
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        rootScrollView.delegate = self
        rootScrollView.contentSize = CGSizeMake(376, 214)
        baseScrollView.contentSize = CGSizeMake(view.frame.width, 986)
        addImagesAndVideos()
    }
    
    func addImagesAndVideos()
    {
        for (index, image) in images.enumerate()
        {
            image.frame = CGRectMake(
                CGFloat(index) * rootScrollView.frame.width,
                0,
                rootScrollView.frame.width,
                rootScrollView.frame.height
            )
            image.contentMode = UIViewContentMode.ScaleAspectFill
            rootScrollView.addSubview(image)
        }
        
        
        for (index, video) in videos.enumerate()
        {
            guard let path = NSBundle.mainBundle().pathForResource(video.url, ofType:"mp4") else {
                continue
            }
            
            let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
            let playerLayer = AVPlayerLayer(player: player)
            
            let videoView = UIView(frame: CGRectMake(
                (CGFloat(index) * rootScrollView.frame.width) + (CGFloat(images.count) * rootScrollView.frame.width),
                0,
                rootScrollView.frame.width,
                rootScrollView.frame.height + 20
            ))
            
            playerLayer.frame = videoView.bounds
            videoView.layer.addSublayer(playerLayer)
            videoView.backgroundColor = UIColor.blackColor()
            
            let image = UIImage(named: "videoPlayButton") as UIImage?
            let button   = UIButton(type: UIButtonType.Custom) as UIButton
            button.frame = CGRectMake(140, 49, 100, 100)
            button.setImage(image, forState: .Normal)
            button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            button.tag = index
            videoView.addSubview(button)
            
            rootScrollView.addSubview(videoView)
        }
        
        rootScrollView.contentSize = CGSizeMake(
            CGFloat(images.count + videos.count) * rootScrollView.frame.width,
            rootScrollView.frame.height
        )
        
        pageControl.numberOfPages = images.count + videos.count
    }
    
    func addVideoPlayer(file: String)
    {
        guard let path = NSBundle.mainBundle().pathForResource(file, ofType:"mp4") else {
            return
        }

        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
    
    func btnTouched(sender: AnyObject?)
    {
        guard let tag = sender?.tag else { return }
        addVideoPlayer(videos[tag].url)
    }
}

extension ViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let fractionalPage = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(lround(Double(fractionalPage)))
    }
}

extension ViewController: BookTripViewControllerDelegate
{
    func didConfirmTrip()
    {
        joinButton.setTitle("DU ER MED!", forState: UIControlState.Normal)
        joinButton.backgroundColor = UIColor(red: 12/255, green: 198/255, blue: 30/255, alpha: 1)
        joinButton.enabled = false
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.joinViewController.view.frame.origin.y = self.view.bounds.height + 50
            self.baseScrollView.alpha = 1
            self.baseScrollView.backgroundColor = UIColor.whiteColor()
        }
    }
}

