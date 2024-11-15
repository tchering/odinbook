// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
import PasswordVisibility from '@stimulus-components/password-visibility'

application.register('password-visibility', PasswordVisibility)
eagerLoadControllersFrom("controllers", application);
// import NavbarController from "./navbar_controller";
// application.register("navbar", NavbarController);
