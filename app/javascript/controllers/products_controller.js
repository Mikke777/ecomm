import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { size: String, product: Object }

  addToCart() {
    if (!this.sizeValue) {
      this.displayError("Please select a size")
      return
    }

    console.log("product: ", this.productValue)
    const cart = localStorage.getItem("cart")
    let cartArray = []
    if (cart) {
      cartArray = JSON.parse(cart)
      const foundIndex = cartArray.findIndex(item => item.id === this.productValue.id && item.size === this.sizeValue)
      if (foundIndex >= 0) {
        cartArray[foundIndex].quantity = parseInt(cartArray[foundIndex].quantity) + 1
      } else {
        cartArray.push({
          id: this.productValue.id,
          name: this.productValue.name,
          price: this.productValue.price,
          size: this.sizeValue,
          quantity: 1
        })
      }
    } else {
      cartArray.push({
        id: this.productValue.id,
        name: this.productValue.name,
        price: this.productValue.price,
        size: this.sizeValue,
        quantity: 1
      })
    }
    localStorage.setItem("cart", JSON.stringify(cartArray))
    this.updateCartIcon()
  }

  selectSize(e) {
    this.sizeValue = e.target.value
    const selectedSizeEl = document.getElementById("selected-size")
    selectedSizeEl.innerText = `Selected Size: ${this.sizeValue}`
  }

  updateCartIcon() {
    const cart = JSON.parse(localStorage.getItem("cart"))
    const cartCount = cart.reduce((acc, item) => acc + item.quantity, 0)
    const cartIcon = document.getElementById("cart-icon")
    const cartCountEl = document.getElementById("cart-count")
    cartIcon.classList.add("text-red-500")
    cartCountEl.innerText = cartCount
    if (cartCount === 0) {
      cartCountEl.classList.add("hidden")
    } else {
      cartCountEl.classList.remove("hidden")
    }
  }

  displayError(message) {
    const errorEl = document.getElementById("error-message")
    errorEl.innerText = message
    errorEl.classList.remove("hidden")
  }
}
