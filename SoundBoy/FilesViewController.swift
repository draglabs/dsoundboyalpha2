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

var songs: [(songName: String, id: Int)] = []


class FilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilesDisplayLogic {
    var interactor: FilesBuisnessLogic?
    var router: (NSObjectProtocol & FilesRoutingLogic & FilesDataPassing)?

    let backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
    let backLayer = UIImageView(image: #imageLiteral(resourceName: "backLayer"))
    
    let table = UITableView()
    //Need to load the list of files from the user. When they are pressed, I need a new view with navigation that takes them to the play screen.
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //get cells organized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: UI Setup and Constraints
    
    func setupUI()
    {
        view.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTouch(sender:))))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "background"))
        imageView.frame = view.frame
        view.addSubview(imageView)
        tableConstraints()
        backLayer.frame = view.frame
        view.addSubview(backLayer)
        backgroundView.frame = view.frame
        view.addSubview(backgroundView)
    }
    
    func tableConstraints()
    {
        //Add contraints
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows = to the number of files
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let (songName, _) = songs[indexPath.row]
        cell.textLabel?.text = songName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func handleTouch(sender:UITapGestureRecognizer) {
       
    }
    
}


