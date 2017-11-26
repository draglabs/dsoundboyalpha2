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
 
    // MARK: Properties
     @IBOutlet weak  var collection:FilesCollectionView!
    func setupUI() {
     title = "FILES"
      let titleDict: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont(name:"Avenir-Book", size:20)!,NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict
      collection.exportPressed = exportJam
    }
  
   func displayJams(viewModel: Files.ViewModel) {
    collection.display(jams: viewModel.Activity)
   }
}


extension FilesViewController:FilesCollectionViewDelegate {
  func filesCollectionViewDidSelect(collection: FilesCollectionView, index:Int) {
    self.router?.routeToDetail(index: index)
  }
  
  func exportJam(index:Int) {
    router?.routeToExport(index:index)
  }
}


