//
//  MoviesTabBarContorller.swift
//  Movies
//
//  Created by Emin Emini on 11/05/2020.
//  Copyright © 2020 Emin Emini. All rights reserved.
//

import UIKit

class MoviesTabBarContorller: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        //Create three navigation controllers to serve as the root screen controllers for this tabBarcontroller
        let upcomingNavigationController = geGenericNavigationViewController()
        let nowPlayingNavigationController  = geGenericNavigationViewController()
        let topRatedNavigationController = geGenericNavigationViewController()
        let popularNavigationController = geGenericNavigationViewController()
        let companiesNavigationController  = geGenericNavigationViewController()
        
        upcomingNavigationController.tabBarItem.tag = 1
        nowPlayingNavigationController.tabBarItem.tag = 2
        topRatedNavigationController.tabBarItem.tag = 3
        popularNavigationController.tabBarItem.tag = 4
        companiesNavigationController.tabBarItem.tag = 0
        
        //Try to set the moviesType for all the moviesListView controllers
        let upcomingMoviesViewController  = upcomingNavigationController.topViewController as! MovieListViewController
        let topRatedMoviesViewController  = topRatedNavigationController.topViewController as! MovieListViewController
        let nowPlayingMoviesController  = nowPlayingNavigationController.topViewController as! MovieListViewController
        let popularMoviesViewController  = popularNavigationController.topViewController as! MovieListViewController
        let compoaniesMoviesViewController  = companiesNavigationController.topViewController as! MovieListViewController
    
        upcomingMoviesViewController.moviesType =  MoviesType.upcoming
        topRatedMoviesViewController.moviesType =  MoviesType.topRated
        nowPlayingMoviesController.moviesType   =  MoviesType.nowPlaying
        popularMoviesViewController.moviesType  =  MoviesType.popular
        compoaniesMoviesViewController.moviesType  =  MoviesType.companies
        
        //customize tab items based on moviesType
        upcomingMoviesViewController.prepareTabItem()
        topRatedMoviesViewController.prepareTabItem()
        nowPlayingMoviesController.prepareTabItem()
        popularMoviesViewController.prepareTabItem()
        compoaniesMoviesViewController.prepareTabItem()
        
        
        //set the root view controllers
        viewControllers = [popularNavigationController, topRatedNavigationController, companiesNavigationController, nowPlayingNavigationController, upcomingNavigationController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func geGenericNavigationViewController() -> UINavigationController {
        let storyboard = self.storyboard!
        return storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    }
    
    
    /*
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = self.tabBarController!.selectedIndex
        if tabBarIndex == 2 {
            isShowingCompanies = true
            print("true")
            print("true")
            print("true")
            print("true")
            print("true")
        } else {
            isShowingCompanies = false
            print("false")
            print("false")
            print("false")
            print("false")
        }
    } */
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 { // do something
            isShowingCompanies = true
        } else if item.tag == 1 {
            isShowingCompanies = false
        } else if item.tag == 2 {
            isShowingCompanies = false
        } else if item.tag == 3 {
            isShowingCompanies = false
        } else if item.tag == 4 {
            isShowingCompanies = false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //super.tabBarController(tabBarController, didSelect: viewController)
        if viewController.tabBarItem.tag == 0 { // do something
            isShowingCompanies = true
        } else if viewController.tabBarItem.tag == 1 {
            isShowingCompanies = false
        } else if viewController.tabBarItem.tag == 2 {
            isShowingCompanies = false
        } else if viewController.tabBarItem.tag == 3 {
            isShowingCompanies = false
        } else if viewController.tabBarItem.tag == 4 {
            isShowingCompanies = false
        }
        
        
    }
}

