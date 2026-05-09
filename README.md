# 🏆 League-Lens

![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=flat-square&logo=swift)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey?style=flat-square&logo=apple)
![Architecture](https://img.shields.io/badge/Architecture-MVP-blue?style=flat-square)

League-Lens is a sleek iOS application for sports enthusiasts to explore teams, track favorite leagues, and stay updated with the latest match events—complete with offline support and premium UI animations.

## 📸 Screenshots

|                                              Home & Sports                                               |                                             League Insights                                              |                                               Team Roster                                                |                                                 Leagues                                                  |
| :------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/9144ba83-9f80-43aa-b10e-7eb3b5861c00" width="200"/> | <img src="https://github.com/user-attachments/assets/35872336-b425-499b-9f3a-be2f06bbb54a" width="200"/> | <img src="https://github.com/user-attachments/assets/fdc6c10a-1cd6-4031-87c4-787c77926bd4" width="200"/> | <img src="https://github.com/user-attachments/assets/b0f67f9e-4acb-498e-a22c-05cce77030b3" width="200"/> |

## ✨ Features

* **Interactive Dashboard:** Browse sports (Football, Basketball, Tennis, Cricket) with animated banners.
* **League & Match Tracking:** View upcoming fixtures, historical results, and participating teams.
* **Team Rosters:** Detailed player profiles categorized by field position.
* **Offline Favorites:** Save leagues for quick, offline access via CoreData.
* **Premium UX:** Features Dark Mode, Lottie animations, skeletal loading, and full localization.
* **🏀 Hidden Easter Egg:** Shake your device on the home screen to unlock a physics-based basketball mini-game!

## 🛠️ Tech Stack & Architecture

Built with **Swift** using the **MVP (Model-View-Presenter)** architectural pattern for clean separation of concerns.

* **Networking:** [Alamofire](https://github.com/Alamofire/Alamofire) (Data provided by [AllSportsAPI](https://allsportsapi.com/))
* **Local Storage:** CoreData
* **UI/UX:** Programmatic UI & Storyboards, [SkeletonView](https://github.com/Juanpe/SkeletonView), [SDWebImage](https://github.com/SDWebImage/SDWebImage), and [Lottie](https://github.com/airbnb/lottie-ios).

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone [https://github.com/Alaa7Hany/MAD46_Sports.git](https://github.com/Alaa7Hany/MAD46_Sports.git)
   ```
2. Open the project in Xcode:
    
    Bash
    
    ```
    cd MAD46_Sports
    open MAD46_Sports.xcodeproj
    ```
    
3. Xcode will automatically resolve and fetch the required dependencies via Swift Package Manager. Once the indexing finishes, build and run the project.
    

## 🎓 Acknowledgments

This project was developed as part of the Information Technology Institute (ITI) Mobile Native Track.

**Team Members:**

- Alaa El-Gebaly
    
- Ahlam Gomaa
