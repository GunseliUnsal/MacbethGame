//
//  ContentView.swift
//  MacbethGame
//
//  Created by Günseli Ünsal on 10.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var currentView: String = "intro"
    
    var body: some View {
        if currentView == "intro" {
            IntroView(onBeginTapped: {
                currentView = "chapter1"
            })
        } else if currentView == "chapter1" {
            Chapter1View(onContinue: {
                currentView = "transition1"
            })
        } else if currentView == "transition1" {
            TransitionView(
                title: "The Prophecy Lingers",
                description: "The witches vanish into the mist, and the forest falls silent once again. Banquo and Macbeth ponder the prophecies they heard. Suddenly, a messenger appears with news: King Duncan of Scotland has appointed Macbeth as Thane of Cawdor. The first part of the prophecy has come true. Macbeth is bewildered; is this mere coincidence, or do the witches' words hold deeper meaning?",
                buttonLabel: "Continue to Castle Arrival",
                theme: .forest,
                onContinue: {
                    currentView = "chapter2"
                }
            )
        } else if currentView == "chapter2" {
            Chapter2View(onContinue: {
                currentView = "transition2"
            })
        } else if currentView == "transition2" {
            TransitionView(
                title: "Ambition Awakens",
                description: "Ambition stirs within Macbeth. Lady Macbeth reads her husband's letter and believes in the prophecy. News arrives that King Duncan will visit the castle. As night approaches, Macbeth and Lady Macbeth begin to plot their path to the throne.",
                buttonLabel: "Prepare for Duncan's Arrival",
                theme: .castle,
                onContinue: {
                    currentView = "chapter3"
                }
            )
        } else if currentView == "chapter3" {
            Chapter3View(onContinue: {
                currentView = "transition3"
            })
        } else if currentView == "transition3" {
            TransitionView(
                title: "The Crown Stained with Blood",
                description: "King Duncan's body is discovered in the morning. Macbeth, in a fit of rage, accuses the guards and kills them. However, suspicions grow as others notice Lady Macbeth's composed demeanor. Macbeth becomes king, but whispers of betrayal begin to spread.",
                buttonLabel: "Continue to the Banquet",
                theme: .bloody,
                onContinue: {
                    currentView = "chapter4"
                }
            )
        } else if currentView == "chapter4" {
            Chapter4View(onContinue: {
                currentView = "transition4"
            })
        } else if currentView == "transition4" {
            TransitionView(
                title: "Haunted by Guilt",
                description: "Macbeth flees the banquet hall in shock after seeing Banquo's ghost. Servants whisper that Macbeth has lost his mind. Lady Macbeth tries to control the situation, but throughout the night, Macbeth's peace is shattered. The ghosts of the past haunt him, and new threats approach.",
                buttonLabel: "Prepare for War",
                theme: .haunted,
                onContinue: {
                    currentView = "chapter5"
                }
            )
        } else if currentView == "chapter5" {
            Chapter5View(onContinue: {
                currentView = "chapter6"
            })
        } else if currentView == "chapter6" {
            Chapter6View(onContinue: {
                currentView = "transition5"
            })
        } else if currentView == "transition5" {
            TransitionView(
                title: "The Final Hour",
                description: "Macbeth stands firm at Dunsinane Castle, awaiting his fate. As Macduff's army approaches from Birnam Wood, the witches' prophecy begins to unfold. Lady Macbeth's guilt-ridden death shatters his spirit. While the battle rages, Macbeth fights bravely, but when Macduff reveals he was not 'born of woman,' Macbeth's fate is sealed. Power, greed, and blood have led him to this end.",
                buttonLabel: "Witness the Fall of Macbeth",
                theme: .battle,
                onContinue: {
                    currentView = "epilogue"
                }
            )
        } else if currentView == "epilogue" {
            TransitionView(
                title: "The Restoration of Order",
                description: "Macduff presents Macbeth's head to Malcolm, who ascends to the throne of Scotland. Peace returns to the land, but Macbeth's tale serves as a stark lesson about the destructive nature of ambition and power.",
                buttonLabel: "Play Again",
                theme: .epilogue,
                onContinue: {
                    currentView = "intro"
                }
            )
        } else {
            EpilogueView(onPlayAgain: {
                currentView = "intro"
            })
        }
    }
}

#Preview {
    ContentView()
}
