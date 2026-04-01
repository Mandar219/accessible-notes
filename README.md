# Accessible Notes App

An accessibility-first note-taking iOS application, designed to provide a smooth and inclusive experience for users who rely on assistive technologies such as VoiceOver and Dynamic Type.

------------------------------------------------------------------------

## Overview

Accessible Notes is a lightweight iOS app that allows users to create, edit, search, and manage notes. Unlike typical note apps, this project
is built with accessibility as a primary design principle, not an afterthought.

The app emphasizes: 
- Clear structure and navigation 
- Screen reader-friendly layouts 
- Readable, scalable text 
- Low-friction
interactions

------------------------------------------------------------------------

## Features

-   Create, edit, and delete notes
-   Pin and unpin important notes
-   Search notes by title or content
-   Clean and simple SwiftUI-based UI

------------------------------------------------------------------------

## Accessibility-First Design

This project was intentionally designed with accessibility in mind from the beginning. The goal was to reduce interaction friction and ensure usability for visually impaired users.

### Key Accessibility Features

#### 1. VoiceOver Support

-   Custom accessibility labels
-   Clear accessibility hints for actions
-   Decorative elements hidden from screen readers where appropriate
-   Logical reading order maintained

#### 2. Simplified Interaction Model

-   Important actions are exposed via clearly labeled buttons
-   Destructive actions use confirmation dialogs
-   Reduced reliance on gesture-only interactions

#### 3. Dynamic Type Support

-   Uses semantic text styles
-   Layout allows text to scale and wrap without clipping

#### 4. High Contrast-Friendly UI

-   Avoids overly faint colors
-   Uses clear visual separation with borders and spacing
-   Does not rely solely on color to convey meaning

------------------------------------------------------------------------

## Screenshots

|  |  |
| :---: | :---: |
| ![](AccessibleNotes/Screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-31%20at%2021.05.25.png) | ![](AccessibleNotes/Screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-31%20at%2021.06.36.png) |

| | |
| :---: | :---: |
| ![](AccessibleNotes/Screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-31%20at%2021.07.47.png) | ![](AccessibleNotes/Screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-31%20at%2021.07.55.png) |

| | |
| :---: | :---: |
| ![](AccessibleNotes/Screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-31%20at%2021.06.43.png) | ![](AccessibleNotes/Screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-31%20at%2021.17.33.png) |


------------------------------------------------------------------------

## Getting Started

1.  Clone the repository
2.  Open the project in Xcode
3.  Build and run on simulator or device
