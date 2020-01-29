//
//  ViewController.swift
//  Programmatic-UI-Xibs-Storyboards
//
//  Created by Alex Paul on 1/29/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {
    
    private let podcastView = PodcastView()
    
    private var podcasts = [Podcast]() {
        didSet {
            DispatchQueue.main.async {
                self.podcastView.collectionView.reloadData()
            }
        }
    }
    
    override func loadView() {
        view = podcastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Podcasts"
        podcastView.collectionView.dataSource = self
        podcastView.collectionView.delegate = self
        //register collection view cell
        //podcastView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "podcastCell")
        
        //register collectionView cell using xib/nib
        podcastView.collectionView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellWithReuseIdentifier: "podcastCell")
        
        fetchPodcasts()
    }
    
    private func fetchPodcasts(_ name: String = "swift") {
        PodcastAPIClient.fetchPodcast(with: name) { (result) in
            switch result {
            case .failure(let appError):
                print("error fetching podcasts: \(appError)")
            case .success(let podcasts):
                self.podcasts = podcasts
            }
        }
    }
    
}

extension PodcastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
            fatalError("does not conform to xib file")
        }
        //    cell.backgroundColor = .green
        return cell
    }
}

extension PodcastViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //override the default values of the itemSize layout from the collectionView property initializer in the PodcastView
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.95 //95% of device
        return CGSize(width: itemWidth, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let podcast = podcasts[indexPath.row]
        
        // segue to the PodcastDetailController
        // access the PodcastDetailController from Storyboard
        let podcastDetailStoryboard = UIStoryboard(name: "PodcastDetail", bundle: nil)
        guard let podcastDetailController = podcastDetailStoryboard.instantiateViewController(identifier: "PodcastDetail") as? PodcastDetailController else {
            fatalError("could not downcast to PodcastDetailController")
        }
        podcastDetailController.podcast = podcast
        
        //in the coming weeks or next week we will pass data using initializer / dependency initializer
        navigationController?.pushViewController(podcastDetailController, animated: true)
        
        //show(podcastDetailController, sender: nil)
    }
}


