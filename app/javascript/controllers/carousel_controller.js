// app/javascript/controllers/carousel_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "slide", "dots"]

  // ── État ────────────────────────────────────────────────
  currentIndex = 0

  // ── Au montage ──────────────────────────────────────────
  connect() {
    this.totalSlides = this.slideTargets.length
    this.updateDots()

    // Détection swipe tactile & souris
    this._startX = 0
    this._isDragging = false

    // Liaison des événements pour le swipe
    this.trackTarget.addEventListener("touchstart", this._onTouchStart.bind(this), { passive: true })
    this.trackTarget.addEventListener("touchend", this._onTouchEnd.bind(this), { passive: true })
    this.trackTarget.addEventListener("mousedown", this._onMouseDown.bind(this))
    this.trackTarget.addEventListener("mouseup", this._onMouseUp.bind(this))
  }

  disconnect() {
    this.trackTarget.removeEventListener("touchstart", this._onTouchStart)
    this.trackTarget.removeEventListener("touchend", this._onTouchEnd)
    this.trackTarget.removeEventListener("mousedown", this._onMouseDown)
    this.trackTarget.removeEventListener("mouseup", this._onMouseUp)
  }

  // ── Navigation par dot ──────────────────────────────────
  goTo(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    this.moveTo(index)
  }

  // ── Navigation par flèches ──────────────────────────────
  next() {
    if (this.currentIndex < this.totalSlides - 1) {
      this.moveTo(this.currentIndex + 1)
    } else {
      // Optionnel : Retour au début si on est à la fin
      this.moveTo(0)
    }
  }

  prev() {
    if (this.currentIndex > 0) {
      this.moveTo(this.currentIndex - 1)
    } else {
      // Optionnel : Aller à la fin si on est au début
      this.moveTo(this.totalSlides - 1)
    }
  }

  // ── Déplacement principal ────────────────────────────────
  moveTo(index) {
    if (index < 0 || index >= this.totalSlides) return

    this.currentIndex = index

    // Correction du calcul de l'offset
    // On récupère la largeur d'un slide + le gap CSS (12px)
    // const slideWidth = this.slideTargets[0].clientWidth
    // const gap = 12
    // const offset = index * (slideWidth + gap)
    const slideWidth = this.slideTargets[0].getBoundingClientRect().width
    const gap = 12
    const offset = index * (slideWidth + gap)

    this.trackTarget.style.transform = `translateX(-${offset}px)`
    this.updateDots()
  }

  // ── Mise à jour des dots ─────────────────────────────────
  updateDots() {
    if (!this.hasDotsTarget) return

    const dots = this.dotsTarget.querySelectorAll(".carousel-dot")
    dots.forEach((dot, i) => {
      dot.classList.toggle("carousel-dot--active", i === this.currentIndex)
      dot.setAttribute("aria-pressed", i === this.currentIndex ? "true" : "false")
    })
  }

  // ── Logique de Swipe ─────────────────────────────────────
  _onTouchStart(e) {
    this._startX = e.touches[0].clientX
  }

  _onTouchEnd(e) {
    const deltaX = e.changedTouches[0].clientX - this._startX
    this._handleSwipe(deltaX)
  }

  _onMouseDown(e) {
    this._startX = e.clientX
    this._isDragging = true
  }

  _onMouseUp(e) {
    if (!this._isDragging) return
    this._isDragging = false
    const deltaX = e.clientX - this._startX
    this._handleSwipe(deltaX)
  }

  _handleSwipe(deltaX) {
    const threshold = 50 // Sensibilité du swipe
    if (deltaX < -threshold) this.next()
    if (deltaX > threshold) this.prev()
  }
}
