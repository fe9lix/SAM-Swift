
[![SAM](https://img.shields.io/badge/SAM-pattern-green.svg)](http://sam.js.org)
[![Swift](https://img.shields.io/badge/swift-4.0-orange.svg)](https://developer.apple.com/swift/)
[![Gif](https://img.shields.io/badge/coding-love-red.svg)](http://thecodinglove.com/)

# SAM-Swift

The SAM (State-Action-Model) pattern in Swift.

SAM is an application architecture pattern first [introduced by Jean-Jacques Dubray](http://sam.js.org). The principles of the pattern are, in turn, based on TLA+ (Temporal Logic of Actions), developed by [Leslie Lamport](https://www.microsoft.com/en-us/research/people/lamport/).

## Programming Model

The entire pattern can be described with:  

`View=State(Model.present(Action(event))).then(nap)`

which translates to: Actions, triggered by view events (Intents), present a dataset (Proposal) to the Model that accepts or rejects the data and performs the actual mutation of its property values. After the Model mutation, the state representation is created based on the derived (control) state. The View displays this state representation. Finally, the NAP (next action predicate) computes any automatic next actions based on the current app state.

## Features

* Single Model Tree
* Unidirectional data flow
* View as a pure function of the model
* Reactive loop
* Reusable Actions
* Concept of a "step" for state mutations

## Advantages 

Compared to other approaches such as Redux, Elm etc., SAM comes with a number of key advantages:

* The pattern processes events as a computation "step" with a clearly defined flow: propose (Action), accept (Model) and learn (State). Unlike other patterns that promote immutability, mutability is an explicit "first class citizen" in SAM (programming is all about state mutation, not state avoidance through immutability.) 

* SAM is much simpler than Redux/Elm that require additional modules (Thunks, Effects, Sagas etc.) for typical tasks needed in modern async. applications.

* Actions are completely decoupled from the View and Model. The Action does not need to know about the Model (which would require the Action to have the entire knowledge of the Model and application state). Actions are modular and reusable. Unlike in Redux/Elm where Actions are only Intents by default and side effects must be separately handled, SAM Actions can perform async. API calls.

* Complete decoupling of business logic: Views have no knowledge of the Model or Actions. Views are functions of the State, which are functions of the Model. State itself is stateless! The state representation is only computed after the Model has been fully mutated.

* The programming model can be used both client- and serverside.

More info on the [SAM website](http://sam.js.org).

## Example App

The app folder contains a complete and fully documented example of the SAM pattern. The app basically loads, extracts, and displays animated Gifs from the site "The Coding Love". 

<img src="https://raw.githubusercontent.com/fe9lix/SAM-Swift/master/resources/app.png" width="464">
