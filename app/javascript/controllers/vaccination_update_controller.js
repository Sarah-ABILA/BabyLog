import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const checkbox = event.target
    const id = checkbox.dataset.vaccinationId
    const isChecked = checkbox.checked
    const label = document.getElementById(`name-${id}`)

    // On envoie l'info à Rails
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
        // On barre le texte si c'est coché
        label.classList.toggle('text-decoration-line-through', isChecked)
        label.classList.toggle('text-muted', isChecked)
      }
    })
  }
}
