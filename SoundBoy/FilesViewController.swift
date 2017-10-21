//
//  FilesViewController.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

protocol FilesDisplayLogic:class {
  func displayJams(viewModel:Files.ViewModel)
  
 }

class FilesViewController: UIViewController, FilesDisplayLogic {
    var interactor: FilesBuisnessLogic?
    var router: (NSObjectProtocol & FilesRoutingLogic & FilesDataPassing)?
  var collection:FilesCollectionView!
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = FilesInteractor()
        let presenter = FilesPresenter()
        let router = FilesRouter()
      
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter 
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
      let request = Files.Request()
      interactor?.loadRecordings(request: request)
    }
 
    // MARK: UI Setup and Constraints
    
    func setupUI() {

      view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
       title = "FILES"
      let titleDict: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont(name:"Avenir-Book", size:16)!,NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict
       
    }
  
  
   func displayJams(viewModel: Files.ViewModel) {
    
    collection = FilesCollectionView(frame: view.bounds, activity: viewModel.Activity)
    collection.delegate = self
    view.addSubview(collection)
   }
}


extension FilesViewController:FilesCollectionViewDelegate {
  func filesCollectionViewDidSelect(collection: FilesCollectionView, index:Int) {
    self.router?.routeToDetail(index: index)
  }
}


