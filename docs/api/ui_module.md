---
title: UI Module
description: API reference for UI module
---


# UI Module

UI Module is the main object.


---

## Properties

### `UiModule.config`

Configuration for UiModule

---

## Functions

### `UiModule.new(): UiModule`

This method is used the intialize a new UiModule.

---

### `UiModule:IntializeButton(button: GuiButton): nil`

Adds animations for when the cursor hovers over, and clisk on a button.

---

### `UiModule:IsWindowVisible(window: Window | Frame): boolean`

Returns whether a frame is open or close (positions in config) If a frame is mid-animation, it will return `true`

---

### `UiModule:CloseWindow(window: Window | Frame): nil`

Closes a window and plays the closing sound in [TODO: put in config] sound service

!!! note

    window can also be 

---

### `UiModule:CloseAllWindows(): nil`

Calls `UiModule:CloseWindow` on all windows with the `window` attribute set to true in `PlayerGui.Main`.

---

### `UiModule:OpenWindow(window: Window | Frame): nil`

Opens a window and plays the opening sound in [TODO: put in config] sound service

If the window has the `window` attribute set to true, it will call `UiModule:CloseAllWindows`

---

### `UiModule:ToggleWindow(window: Window | Frame): nil`

Calls `UiModule:OpenWindow` or `UiModule:CloseWindow` depending on `UiModule:IsWindowVisible`

---

### `UiModule:IntializeWindow(window: Window): nil`

Adds the `window` attribute to `window`. Calls `UiModule:IntializeButton` on `window.Close`. When `window.Close` is clicked, `UiModule:CloseWindow` is called.

---

### `UiModule:IntializeWindowButton(window: Window, button: GuiButton): nil

pending documentation

---

### `IntializeTabWindow(window: TabWindow, CurrentTab: Tab): nil`

pending documentation