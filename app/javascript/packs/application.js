import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap/dist/js/bootstrap"
import "bootstrap/dist/css/bootstrap"
import "stylesheets/application"

Rails.start()
ActiveStorage.start()

require("quantity_input")
require("toggle_action")
require("order_action")
require("user_action")
require("sort_action")
require("@rails/actiontext")
require("trix")
