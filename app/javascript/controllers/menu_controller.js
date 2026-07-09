import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const menu = document.getElementById("menu")
    menu.classList.toggle("hidden")
  }
}
