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
        backLayer.frame = view.frame
        view.addSubview(backLayer)
        backgroundView.frame = view.frame
        view.addSubview(backgroundView)
        table = UITableView(frame: view.frame, style: .plain)
        
        table.rowHeight = 200
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(self.table)
        tableConstraints()

        
//        table.frame = view.frame
        
        
        
    }
    
    func tableConstraints()
    {
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:10).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-10).isActive = true
//        table.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        table.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        
        table.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
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


