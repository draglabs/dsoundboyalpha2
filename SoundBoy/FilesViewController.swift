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
  
    var table = UITableView()
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
        setupUI()
        let request = Files.Recordings.Request()
        interactor?.loadRecordings(request: request)
    }

    // MARK: UI Setup and Constraints
    
    func setupUI()
    {
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
      
        title = "FILES"
      let titleDict: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont(name:"Avenir-Book", size:16)!,NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleDict
      
      
      table = UITableView(frame:view.frame, style: .plain)

        table.rowHeight = 200
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
      
        tableConstraints()

        
    }
    
    func tableConstraints()
    {
//        table.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0).isActive = true
//        table.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0).isActive = true
//        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
//        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
        //Add contraints
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows = to the number of files
      return  4 //songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
      //let (songName, _) = songs[indexPath.row]
       cell.textLabel?.text = "songName"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func handleTouch(sender:UITapGestureRecognizer) {
       
    }
    
}


