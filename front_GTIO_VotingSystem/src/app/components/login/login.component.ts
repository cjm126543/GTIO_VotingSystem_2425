import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-login',
  imports: [CommonModule, ReactiveFormsModule],
  standalone: true,
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
