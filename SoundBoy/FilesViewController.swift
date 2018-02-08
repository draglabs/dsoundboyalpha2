//
//  FilesViewController.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit
import MessageUI
protocol FilesDisplayLogic:class {
  func displayJams(viewModel:Files.ViewModel)
 }

class FilesViewController: UIViewController, FilesDisplayLogic {
    var interactor: FilesBuisnessLogic?
    var router: (NSObjectProtocol & FilesRoutingLogic & FilesDataPassing)?
    var messageCompose:MFMessageComposeViewController!
  
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
    collection.fileDelegate = self
   }
}

extension FilesViewController:FilesCollectionViewDelegate,MFMessageComposeViewControllerDelegate {
  func shareButtonPressed(collection: FilesCollectionView, index: IndexPath) {
    if let jam = router?.dataStore?.activity?[index.row] {
      
        messageCompose = MFMessageComposeViewController()
        messageCompose.body = "Hey here's the link to download our jam session! \n\(jam.link!)"
        messageCompose.messageComposeDelegate = self
        present(messageCompose, animated: true, completion: nil)
    }
  }
  
  func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    messageCompose.dismiss(animated: true, completion: nil)
    messageCompose = nil
  }
  
  func filesCollectionViewDidSelect(collection: FilesCollectionView, index:Int) {
    self.router?.routeToDetail(index: index)
  }
  func editButtonPressed(collection: FilesCollectionView, index: IndexPath) {
    router?.routeToEdit(index: index.row)
  }
  func exportJam(index:Int) {
    router?.routeToExport(index:index)
  }
  
}


