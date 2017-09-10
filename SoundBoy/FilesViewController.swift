//
//  FilesViewController.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

protocol FilesDisplayLogic:class {
    //To be completed
}


class FilesViewController: UIViewController, FilesDisplayLogic {
    var interactor: FilesBuisnessLogic?
    var router: (NSObjectProtocol & FilesRoutingLogic & FilesDataPassing)?
    
    //Need to load the list of files from the user. When they are pressed, I need a new view with navigation that takes them to the play screen.
  //let table: UITableView = self
      // MARK: Object lifecycle
    
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
//        table.dataSource = self //
//        table.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
      setupUI()
        //get cells organized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: UI Setup and Constraints
    
    func setupUI()
    {
      view.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
      let imageView = UIImageView(image: #imageLiteral(resourceName: "background"))
      title = "FILES"
      let titleDict: [String : Any] = [NSFontAttributeName:UIFont(name:"Avenir-Book", size:16)!,NSForegroundColorAttributeName: UIColor.white]
      navigationController?.navigationBar.titleTextAttributes = titleDict
      imageView.frame = view.frame
      view.addSubview(imageView)
      
        tableConstraints()
    }
    
    func tableConstraints()
    {
        //Add contraints
    }
    
}
