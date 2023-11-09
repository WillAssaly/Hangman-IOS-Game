//
//  PreferencesViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-09-12.
//
import Foundation
import UIKit

// ViewController to handle user preferences such as language and theme.
class PreferencesViewController: UIViewController {
    
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    
   

    // MARK: - View Lifecycle
    override func viewDidLoad() {
           super.viewDidLoad()
                                       // Load the previously saved user preferences.
           loadUserPreferences()
       }
                                                                              // Loads and applies the user's language and theme preferences.
       func loadUserPreferences() {
           
           let selectedLanguage = UserDefaults.standard.string(forKey: "userLanguage") ?? "English"
           
                                                                          // Fetch the stored theme or default to "Dark".
           
           let selectedThemeRawValue = UserDefaults.standard.string(forKey: "userTheme") ?? "Dark"
           
                                                                       // Convert the stored theme to a Theme enum or default to .device.
           
           let selectedTheme = Theme(rawValue: selectedThemeRawValue) ?? .device
           
                                                                    // Set the segmented control to match the stored preferences.
           
           languageSegmentedControl.selectedSegmentIndex = selectedLanguage == "English" ? 0 : 1
           themeSegmentedControl.selectedSegmentIndex = {
                                                                // Map the Theme enum to the segmented control index.
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
        // MARK: - Actions
        // Called when the language selection is changed.
       @IBAction func languageChanged(_ sender: UISegmentedControl) {
                                                                      // Determine the selected language based on the segmented control index.
           let selectedLanguage = sender.selectedSegmentIndex == 0 ? "English" : "Francais"
           
                                                                    // Save the selected language to UserDefaults.
           UserDefaults.standard.set(selectedLanguage, forKey: "userLanguage")
       }
    
    
    // Called when the theme selection is changed.
    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        var selectedTheme: Theme
                                                             // Determine the selected theme based on the segmented control index.
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
                                                     // Save the selected theme to UserDefaults.
                UserDefaults.standard.set(selectedTheme.rawValue, forKey: "userTheme")
                
                                                  // Apply theme immediately
                if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.applyTheme(theme: selectedTheme)
                }
            }
        }
    


   


