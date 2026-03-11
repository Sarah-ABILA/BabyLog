// app/javascript/controllers/carousel_controller.js
// Stimulus controller — Carrousel "Mes enfants"
// Compatible Rails 7+ avec importmap ou esbuild

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "slide", "dots"]

  // ── État ────────────────────────────────────────────────
  currentIndex = 0

  // ── Au montage ──────────────────────────────────────────
  connect() {
    this.totalSlides = this.slideTargets.length
    this.updateDots()

    // Détection swipe tactile
    this._startX   = 0
    this._isDragging = false

    this.trackTarget.addEventListener("touchstart",  this._onTouchStart.bind(this), { passive: true })
    this.trackTarget.addEventListener("touchend",    this._onTouchEnd.bind(this),   { passive: true })
    this.trackTarget.addEventListener("mousedown",   this._onMouseDown.bind(this))
    this.trackTarget.addEventListener("mouseup",     this._onMouseUp.bind(this))
  }

  disconnect() {
    this.trackTarget.removeEventListener("touchstart",  this._onTouchStart)
    this.trackTarget.removeEventListener("touchend",    this._onTouchEnd)
    this.trackTarget.removeEventListener("mousedown",   this._onMouseDown)
    this.trackTarget.removeEventListener("mouseup",     this._onMouseUp)
  }

  // ── Navigation par dot ──────────────────────────────────
  goTo(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    this.moveTo(index)
  }

  // ── Slide suivant ────────────────────────────────────────
  next() {
    if (this.currentIndex < this.totalSlides - 1) {
      this.moveTo(this.currentIndex + 1)
    }
  }

  // ── Slide précédent ─────────────────────────────────────
  prev() {
    if (this.currentIndex > 0) {
      this.moveTo(this.currentIndex - 1)
    }
  }

  // ── Déplacement principal ────────────────────────────────
  moveTo(index) {
    if (index < 0 || index >= this.totalSlides) return

    this.currentIndex = index

    // Calcul du décalage : chaque slide = 100% + gap (12px)
    const slideWidth  = this.slideTargets[0].offsetWidth
    const gap         = 12
    const offset      = index * (slideWidth + gap)

    this.trackTarget.style.transform = `translateX(-${offset}px)`
    this.updateDots()
  }

  // ── Mise à jour des dots ─────────────────────────────────
  updateDots() {
    const dots = this.dotsTarget.querySelectorAll(".carousel-dot")
    dots.forEach((dot, i) => {
      dot.classList.toggle("carousel-dot--active", i === this.currentIndex)
      dot.setAttribute("aria-pressed", i === this.currentIndex ? "true" : "false")
    })
  }

  // ── Swipe tactile ────────────────────────────────────────
  _onTouchStart(e) {
    this._startX = e.touches[0].clientX
  }

  _onTouchEnd(e) {
    const deltaX = e.changedTouches[0].clientX - this._startX
    this._handleSwipe(deltaX)
  }

  // ── Drag souris (desktop) ────────────────────────────────
  _onMouseDown(e) {
    this._startX     = e.clientX
    this._isDragging = true
  }

  _onMouseUp(e) {
    if (!this._isDragging) return
    this._isDragging = false
    const deltaX = e.clientX - this._startX
    this._handleSwipe(deltaX)
  }

  // ── Logique swipe commune ────────────────────────────────
  _handleSwipe(deltaX) {
    const threshold = 40  // px minimum pour déclencher

    if (deltaX < -threshold) {
      this.next()          // swipe gauche → suivant
    } else if (deltaX > threshold) {
      this.prev()          // swipe droite → précédent
    }
  }
}
