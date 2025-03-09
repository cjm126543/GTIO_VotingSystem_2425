import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  imports: [],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent {
  constructor(private router: Router) {}
  login(event: Event) {
    event.preventDefault();
    //alert('Inicio de sesión exitoso');
    this.router.navigate(['/demo']);
  }
  goToRegister() {
    this.router.navigate(['/register']);
  }
}
