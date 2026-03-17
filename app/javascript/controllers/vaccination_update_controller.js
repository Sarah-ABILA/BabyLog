import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // On récupère tous les switches dans ce contrôleur
    const checkboxes = this.element.querySelectorAll("input[type='checkbox']")

    checkboxes.forEach(cb => this.updateColor(cb))
  }

  toggle(event) {
    const checkbox = event.target
    const id = checkbox.dataset.vaccinationId
    const isChecked = checkbox.checked
    const label = document.getElementById(`name-${id}`)

    // Mise à jour immédiate de la couleur
    this.updateColor(checkbox)

    fetch(`/vaccinations/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ status: isChecked })
    })
    .then(response => {
      if (response.ok) {
        label?.classList.toggle('text-decoration-line-through', isChecked)
        label?.classList.toggle('text-muted', isChecked)
      }
    })
  }

  updateColor(checkbox) {
    if (checkbox.checked) {
      checkbox.style.backgroundColor = "#4CAF50"   // vert
      checkbox.style.borderColor = "#4CAF50"
    } else {
      checkbox.style.backgroundColor = "#f8d7da"   // rouge clair
      checkbox.style.borderColor = "#f5c2c7"
    }
  }
}
