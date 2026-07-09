import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.toggle()
  }

  toggle() {
    const freq = this.element.value
    const form = this.element.closest("form")

    const billingDay = form.querySelector("#new-billing-day")
    const dayOfWeek = form.querySelector("#new-day-of-week")

    if (billingDay && dayOfWeek) {
      if (freq === "weekly") {
        billingDay.classList.add("hidden")
        dayOfWeek.classList.remove("hidden")
      } else {
        billingDay.classList.remove("hidden")
        dayOfWeek.classList.add("hidden")
      }
    }

    // Also handle inline edit forms
    form.querySelectorAll("[id^=edit-billing-day-], [id^=edit-day-of-week-]").forEach(el => {
      const isBilling = el.id.startsWith("edit-billing-day-")
      if (freq === "weekly") {
        if (isBilling) el.classList.add("hidden")
        else el.classList.remove("hidden")
      } else {
        if (isBilling) el.classList.remove("hidden")
        else el.classList.add("hidden")
      }
    })
  }
}
