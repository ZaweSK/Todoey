# Todoey

## Overview
App serves as a to do list. User can add a list, and then add items to that list. Each list has a specific color and 
each list item is colored in grade of that color.  This creates an effect of gradiently coloured to do lists. Which, 
IMHO, is kind of neat.
Items can be searched through with the use of search bar. Each item can be checked or unchecked.
User can specify color for his list with use of color picker. App uses Realm database for data 
persistence.

<img align="right" src="todoey.gif">


## Implemented bits
* use of table view controllers, segue between different tableVCs
* use navigation controller 
* use Realm for data persistence 
* creating Realm Object models
* customize the look of NavigationBar
* using ChameleonFramework for colors - contrasting colors, color darkening and lightening
* use alert controllers for adding items and categories, dismissing alert controllers when user taps background
* search bar implementation
* use of ChromaColorPicker pod to present color picker

