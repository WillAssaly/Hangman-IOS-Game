//
//  PreferencesViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-09-12.
//
import Foundation
import UIKit

class PreferencesViewController: UIViewController {
    
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    
   


    override func viewDidLoad() {
           super.viewDidLoad()
           
           loadUserPreferences()
       }
       
       func loadUserPreferences() {
           let selectedLanguage = UserDefaults.standard.string(forKey: "userLanguage") ?? "English"
           let selectedThemeRawValue = UserDefaults.standard.string(forKey: "userTheme") ?? "Dark"
           let selectedTheme = Theme(rawValue: selectedThemeRawValue) ?? .device
           
           languageSegmentedControl.selectedSegmentIndex = selectedLanguage == "English" ? 0 : 1
           themeSegmentedControl.selectedSegmentIndex = {
               switch selectedTheme {
               case .device:
                   return 0
               case .light:
                   return 1
               case .dark:
                   return 2
               }
           }()
       }
       
       @IBAction func languageChanged(_ sender: UISegmentedControl) {
           let selectedLanguage = sender.selectedSegmentIndex == 0 ? "English" : "Francais"
           UserDefaults.standard.set(selectedLanguage, forKey: "userLanguage")
       }
    
    
    
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        var selectedTheme: Theme
        
        switch sender.selectedSegmentIndex {
                case 0:
                    selectedTheme = .device
                case 1:
                    selectedTheme = .light
                case 2:
                    selectedTheme = .dark
                default:
                    selectedTheme = .device
                }
                UserDefaults.standard.set(selectedTheme.rawValue, forKey: "userTheme")
                
                // Apply theme immediately
                if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.applyTheme(theme: selectedTheme)
                }
            }
        }
    


   


