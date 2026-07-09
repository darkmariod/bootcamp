import { Controller } from "@hotwired/stimulus"

// Toggles light/dark mode by adding/removing the `dark` class on <html>.
// The choice is persisted in localStorage. The initial theme is applied by
// an inline script in the <head> (see application.html.erb) to avoid a flash
// of the wrong theme before Stimulus boots.
export default class extends Controller {
  toggle() {
    const isDark = document.documentElement.classList.toggle("dark")
    localStorage.setItem("theme", isDark ? "dark" : "light")
  }
}
