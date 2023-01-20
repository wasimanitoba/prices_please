import { Application } from "@hotwired/stimulus"

const application = Application.start()

// TODO: disable
application.debug = true
window.Stimulus   = application

export { application }