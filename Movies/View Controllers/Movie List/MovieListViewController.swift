//
//  MovieListViewController.swift
//  Movies
//
//  Created by Emin Emini on 11/05/2020.
//  Copyright © 2020 Emin Emini. All rights reserved.
//

import UIKit
import AlamofireImage
import MBProgressHUD
import ScrollableSegmentedControl

var isShowingCompanies = false

class MovieListViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var companiesSegmentedControll: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toggleViewSwitch: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var connectionErrorView: UIView!
    
    @IBOutlet weak var topErrorConstraint: NSLayoutConstraint!
    @IBOutlet weak var topMovieListConstraint: NSLayoutConstraint!
    @IBOutlet weak var topMovieCollectionConstraint: NSLayoutConstraint!
    
    var isDataLoading = false
    var tableViewLoadingMoreView:InfiniteScrollActivityView?
    var collectionViewLoadingMoreView:InfiniteScrollActivityView?
    var loadingNotification: MBProgressHUD?
    var tableViewRefreshControl: UIRefreshControl!
    var collectionViewRefreshControl: UIRefreshControl!
    var isUserRefreshing = false
    var moviesType = MoviesType.popular    //Defaults to popular movies
    var moviesList: [Movie] = []
    var nextPageToLoad: Int? = 1

    var viewType: ViewType = .list {
        didSet {
            switch viewType {
            case .list:
                self.tableView.isHidden = false
                self.collectionView.isHidden = true
            case .grid:
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
            }
        }
    }
    
    var filteredMoviesList = [Movie]() {
        didSet {
            collectionView.reloadData()
            tableView.reloadData()
            print("Fileterd movie list length \(filteredMoviesList.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadSegmentControll()
        
        setUpViews()
        setUpCollectionView()
        setUpTableView()
        loadMovies()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isShowingCompanies {
            companiesSegmentedControll.isHidden = false
            topErrorConstraint.constant = 0
            topMovieListConstraint.constant = 0
            topMovieCollectionConstraint.constant = 0
        } else {
            companiesSegmentedControll.isHidden = true
            topErrorConstraint.constant = -40
            topMovieListConstraint.constant = -40
            topMovieCollectionConstraint.constant = -40
        }
    }
    
    func setUpViews() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //companiesSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        //companiesSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        tableViewRefreshControl = UIRefreshControl()
        collectionViewRefreshControl = UIRefreshControl()
        searchBar.delegate = self
        searchBar.barStyle = .blackTranslucent
    }
    
    func prepareTabItem () {
        let tabItem = navigationController!.tabBarItem!
        switch moviesType {
        case .nowPlaying:
            title = "Now Playing"
            tabItem.title = title
            tabItem.image = UIImage(named: "nowplaying")
            isShowingCompanies = false
        case .popular:
            title = "Popular"
            tabItem.title = title
            tabItem.image = UIImage(named: "popular")
            isShowingCompanies = false
        case .companies:
            title = "Latest Released"
            tabItem.title = title
            tabItem.image = UIImage(named: "companies")
            isShowingCompanies = false
        case .topRated:
            title = "Top Rated"
            tabItem.title = title
            tabItem.image = UIImage(named: "topratedicon")
            isShowingCompanies = false
        case .upcoming:
            title  = "Upcoming"
            tabItem.title = title
            tabItem.image = UIImage(named: "upcoming")
            isShowingCompanies = false
        }
    }
    
    func isFirstLoad() -> Bool {
        if let nextPageToLoad = nextPageToLoad {
            return nextPageToLoad == 1
        }
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSegmentControll() {
        
        companiesSegmentedControll.segmentStyle = .textOnly
        companiesSegmentedControll.insertSegment(withTitle: "Lucasfilm", image: #imageLiteral(resourceName: "popular"), at: 0)
        companiesSegmentedControll.insertSegment(withTitle: "Disney", image: #imageLiteral(resourceName: "popular"), at: 1)
        companiesSegmentedControll.insertSegment(withTitle: "Pixar", image: #imageLiteral(resourceName: "popular"), at: 2)
        companiesSegmentedControll.insertSegment(withTitle: "Paramount Pictures", image: #imageLiteral(resourceName: "popular"), at: 3)
        companiesSegmentedControll.insertSegment(withTitle: "DMG", image: #imageLiteral(resourceName: "popular"), at: 4)
        companiesSegmentedControll.insertSegment(withTitle: "DreamwWrks", image: #imageLiteral(resourceName: "popular"), at: 5)
            
        
        companiesSegmentedControll.underlineSelected = true
        companiesSegmentedControll.selectedSegmentIndex = 0
            
        companiesSegmentedControll.addTarget(self, action: #selector(MovieListViewController.segmentSelected(sender:)), for: .valueChanged)

        // change some colors
        companiesSegmentedControll.segmentContentColor = UIColor.white
        companiesSegmentedControll.selectedSegmentContentColor = UIColor.white
        companiesSegmentedControll.backgroundColor = UIColor.black
        
        // Turn off all segments been fixed/equal width.
        // The width of each segment would be based on the text length and font size.
        companiesSegmentedControll.fixedSegmentWidth = false
        
        let largerRedTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let largerRedTextHighlightAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]
        let largerRedTextSelectAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]

        companiesSegmentedControll.setTitleTextAttributes(largerRedTextAttributes, for: .normal)
        companiesSegmentedControll.setTitleTextAttributes(largerRedTextHighlightAttributes, for: .highlighted)
        companiesSegmentedControll.setTitleTextAttributes(largerRedTextSelectAttributes, for: .selected)
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        moviesList.removeAll()
        tableView.reloadData()
        collectionView.reloadData()
        switch sender.selectedSegmentIndex {
        case 0:
            selectedCompany = 1
            whenCompanyIsChanged()
        case 1:
            selectedCompany = 2
            whenCompanyIsChanged()
        case 2:
            selectedCompany = 3
            whenCompanyIsChanged()
        case 3:
            selectedCompany = 4
            whenCompanyIsChanged()
        case 4:
            selectedCompany = 5
            whenCompanyIsChanged()
        case 5:
            selectedCompany = 7
            whenCompanyIsChanged()
        default:
            break;
        }
    }
    
    func whenCompanyIsChanged() {
        //print("Changed Company to \(companiesSegmentedControl.selectedSegmentIndex + 1)")
        
        moviesList.removeAll()
        
        loadMovies()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    
    
    @IBAction func togleViewTypeClicked(_ sender: Any) {
        toggleNavBarViewTypeItem()
    }
    
    func toggleNavBarViewTypeItem(){
        switch viewType {
        case .grid:
            toggleViewSwitch.image = UIImage(named:"grid")
            viewType = .list
        case.list:
            toggleViewSwitch.image = UIImage(named:"list")
            viewType = .grid
        }
    }
    
    
    // MARK: - Table and CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetailsViewController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetailsViewController(indexPath: indexPath)
    }
    
    func navigateToDetailsViewController (indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        detailController.movie = self.filteredMoviesList[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
 
    // MARK: - Searchbar delegates implementation
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMoviesList =  searchText.isEmpty ? moviesList : moviesList.filter { (movie) -> Bool in
            return   movie.title!.range(of: searchText , options: .caseInsensitive) != nil
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        //TODO investigate why this not triggering the textDidChange listener, For now
        filteredMoviesList = moviesList
        searchBar.resignFirstResponder()
    }
    
    //Mark:- Pull to refresh
    @objc func onRefresh(){
        print("OnRefresh called")
        nextPageToLoad = 1 //reset the movies to start from the first page
        isUserRefreshing = true
        loadMovies()
    }
    
    
    //Mark:- Networking
    func loadMovies(){
        if isFirstLoad() {
            showLoadingIndicator()
        } else{
            //We are using Activity indicator, instead of ProgressHUD, to show progress on subsequent loads.
            loadingNotification = nil
        }
        if let nextPageToLoad = nextPageToLoad {
            setErrorViewViewWithAnimation(view: connectionErrorView, hidden: true)
            MoviesAPIService.getMoviesList(moviesType: moviesType.rawValue , pageNumber: nextPageToLoad) { (moviesApiResult) in
                //Update ongoingLoading flag
                self.isDataLoading = false
                self.dismissLoadingViews()
                if let moviesApiResult = moviesApiResult {
                    self.nextPageToLoad = moviesApiResult.nextPage
                    if self.isUserRefreshing {
                        self.moviesList.removeAll()
                    }
                    self.moviesList.append(contentsOf: moviesApiResult.moviesList)
                    self.filteredMoviesList.removeAll() ////.................//////
                    self.filteredMoviesList = self.moviesList
                } else{
                    self.setErrorViewViewWithAnimation(view: self.connectionErrorView, hidden: false)
                    print("Error getting movies ")
                }
            }
        }
    }
    
  
    //Mark:- Network activity indicator views
    func showLoadingIndicator()  {
        loadingNotification = MBProgressHUD.showAdded(to: (navigationController?.topViewController?.view)!, animated: true)
        loadingNotification!.mode = MBProgressHUDMode.indeterminate
        loadingNotification!.label.text = "Loading Movies"
    }
    
    func stopLoadingMoreViewAnimation()  {
        self.tableViewLoadingMoreView!.stopAnimating()
        self.collectionViewLoadingMoreView!.stopAnimating()
    }
    
    func setErrorViewViewWithAnimation(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
            view.layer.zPosition = hidden ? 0 : 1
        })
    }
    
    func dismissLoadingViews() {
        self.stopLoadingMoreViewAnimation()
        self.endRefreshControl()
        self.loadingNotification?.hide(animated: true)
    }
    
    func endRefreshControl(){
        collectionViewRefreshControl.endRefreshing()
        tableViewRefreshControl.endRefreshing()
        isUserRefreshing = false
    }
    
    enum ViewType {
        case list
        case grid
    }
    
}
